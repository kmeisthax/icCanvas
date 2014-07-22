#include <icCanvasManager.hpp>

icCanvasManager::TileCache

icCanvasManager::TileCache::TileCache() {};
icCanvasManager::TileCache::~TileCache() {};

void icCanvasManager::TileCache::store(int x, int y, int size, int timeindex, cairo_surface_t* store) {
    icCanvasManager::TileCache::__PosKey pkey = {x, y, size};

    auto &tmap_ref = this->_cache[pkey];
    auto tindex_itr = tmap_ref.find(timeindex);

    cairo_surface_reference(store);
    if (tindex_itr != tmap_ref.end()) {
        cairo_surface_destroy(*tindex_itr);
        tindex_itr->second = store;
    } else {
        icCanvasManager::TileCache::__TimeMap::value_type tkey = {timeindex, store};
        tmap_ref.insert(tkey);
    }
};

cairo_surface_t* icCanvasManager::TileCache::lookup(int x, int y, int size, int timeindex_after = -1, int timeindex_before = -1, int* out_timeindex = NULL) {
    icCanvasManager::TileCache::__PosKey pkey = {x, y, size};

    auto pindex_itr = this->_cache.find(pkey);

    if (pindex_itr != this->_cache.end) {
        auto tindex_first = pindex_itr->begin();
        auto tindex_last = pindex_itr->end();

        if (timeindex_after >= 0) {
            tindex_first = pindex_itr->lower_bound(timeindex_after);
        }

        if (timeindex_before >= 0) {
            tindex_last = pindex_itr->upper_bound(timeindex_before);
        }

        /* TODO: Assumes lower/upper_bound returns sane values (it won't) */
        if (tindex_first != tindex_last) {
            if (out_timeindex) *out_timeindex = tindex_first->first;
            return tindex_first->second;
        }
    } else {
        return NULL;
    }
};
