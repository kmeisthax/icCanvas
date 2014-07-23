#include <icCanvasManager.hpp>

icCanvasManager::TileCache::TileCache() {};
icCanvasManager::TileCache::~TileCache() {};

icCanvasManager::TileCache::TileCacheQuery::TileCacheQuery() {
    this->x_cond_lower = false;
    this->x_cond_higher = false;
    this->y_cond_lower = false;
    this->y_cond_higher = false;
    this->size_cond_lower = false;
    this->size_cond_higher = false;
    this->time_cond_lower = false;
    this->time_cond_higher = false;
};
icCanvasManager::TileCache::TileCacheQuery::~TileCacheQuery() {};

void icCanvasManager::TileCache::TileCacheQuery::query_x_gte(int x_lower_bound) {
    this->x_lower = x_lower_bound;
    this->x_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_x_eq(int x_equals) {
    this->query_x_gte(x_equals);
    this->query_x_lt(x_equals + 1);
};
void icCanvasManager::TileCache::TileCacheQuery::query_x_lt(int x_higher_bound) {
    this->x_higher = x_higher_bound;
    this->x_cond_higher = true;
};

void icCanvasManager::TileCache::TileCacheQuery::query_y_gte(int y_lower_bound) {
    this->y_lower = y_lower_bound;
    this->y_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_y_eq(int y_equals) {
    this->query_y_gte(y_equals);
    this->query_y_lt(y_equals + 1);
};
void icCanvasManager::TileCache::TileCacheQuery::query_y_lt(int y_higher_bound) {
    this->y_higher = y_higher_bound;
    this->y_cond_higher = true;
};

void icCanvasManager::TileCache::TileCacheQuery::query_size_gte(int size_lower_bound) {
    this->size_lower = size_lower_bound;
    this->size_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_size_eq(int size_equals) {
    this->query_size_gte(size_equals);
    this->query_size_lt(size_equals + 1);
};
void icCanvasManager::TileCache::TileCacheQuery::query_size_lt(int size_higher_bound) {
    this->size_higher = size_higher_bound;
    this->size_cond_higher = true;
};

void icCanvasManager::TileCache::TileCacheQuery::query_time_gte(int time_lower_bound) {
    this->time_lower = time_lower_bound;
    this->time_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_time_eq(int time_equals) {
    this->query_time_gte(time_equals);
    this->query_time_lt(time_equals + 1);
};
void icCanvasManager::TileCache::TileCacheQuery::query_time_lt(int time_higher_bound) {
    this->time_higher = time_higher_bound;
    this->time_cond_higher = true;
};

void icCanvasManager::TileCache::store(int x, int y, int size, int timeindex, cairo_surface_t* store) {
    icCanvasManager::TileCache::TileCacheQuery tquery;
    tquery.query_x_eq(x);
    tquery.query_y_eq(y);
    tquery.query_size_eq(size);
    tquery.query_time_eq(timeindex);

    std::vector<int> tids = this->lookup(tquery);
    icCanvasManager::TileCache::Tile *tref = NULL;

    if (tids.size() > 0) {
        tref = &this->tile_at(tids.at(0));
    } else {
        this->_storage.emplace_back();
        tref = &this->_storage.back();
        tref->image = NULL;
    }

    if (tref->image != null) cairo_surface_destroy(tref->image);
    *tref = {store, x, y, size, timeindex};
    cairo_surface_reference(store);
};

std::vector<int> icCanvasManager::TileCache::lookup(icCanvasManager::TileCache::TileCacheQuery& query) {
    auto xindex_start = this->_xIndex.begin();
    auto xindex_end = this->_xIndex.end();
    auto xindex_count = this->_xIndex.size();
    auto yindex_start = this->_yIndex.begin();
    auto yindex_end = this->_yIndex.end();
    auto yindex_count = this->_yIndex.size();
    auto sizeindex_start = this->_sizeIndex.begin();
    auto sizeindex_end = this->_sizeIndex.end();
    auto sizeindex_count = this->_sizeIndex.size();
    auto timeindex_start = this->_timeIndex.begin();
    auto timeindex_end = this->_timeIndex.end();
    auto timeindex_count = this->_timeIndex.size();

    if (query.x_cond_lower) {
        xindex_start = this->_xIndex.lower_bound(query.x_lower);
    }
    if (query.x_cond_higher) {
        xindex_end = this->_xIndex.upper_bound(query.x_higher);
    }

    if (query.y_cond_lower) {
        yindex_start = this->_yIndex.lower_bound(query.y_lower);
    }
    if (query.y_cond_higher) {
        yindex_end = this->_yIndex.upper_bound(query.y_higher);
    }

    if (query.size_cond_lower) {
        sizeindex_start = this->_sizeIndex.lower_bound(query.size_lower);
    }
    if (query.size_cond_higher) {
        sizeindex_end = this->_sizeIndex.upper_bound(query.size_higher);
    }

    if (query.time_cond_lower) {
        timeindex_start = this->_timeIndex.lower_bound(query.time_lower);
    }
    if (query.time_cond_higher) {
        timeindex_end = this->_timeIndex.upper_bound(query.time_higher);
    }

    //TODO: Improve index selection, or find a way to count results

    std::vector<int> results;

    for (; xindex_start != xindex_end; xindex_start++) {
        if (query.y_cond_lower && this->_storage.at(xindex_start->second).y < query.y_lower) {
            break;
        }

        if (query.y_cond_upper && this->_storage.at(xindex_start->second).y >= query.y_upper) {
            break;
        }

        if (query.size_cond_lower && this->_storage.at(xindex_start->second).size < query.size_lower) {
            break;
        }

        if (query.size_cond_upper && this->_storage.at(xindex_start->second).size >= query.size_upper) {
            break;
        }

        if (query.time_cond_lower && this->_storage.at(xindex_start->second).time < query.time_lower) {
            break;
        }

        if (query.time_cond_upper && this->_storage.at(xindex_start->second).time >= query.time_upper) {
            break;
        }

        results.push_back(xindex_start->second);
    }

    return results;
};

icCanvasManager::TileCache::Tile& icCanvasManager::TileCache::tile_at(int tileID) {
    return this->_storage.at(tileID);
};
