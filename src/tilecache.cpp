#include <icCanvasManager.hpp>

icCanvasManager::TileCache::TileCache() {
    icCanvasManager::TileCache::TileTree root = {0, 0, 0, -1, -1, -1, -1, -1};
    self->_quadtreeIndex.push_back(root);
};
icCanvasManager::TileCache::~TileCache() {};

icCanvasManager::TileCache::TileCacheQuery::TileCacheQuery() {
    this->x_cond_lower = false;
    this->x_cond_upper = false;
    this->y_cond_lower = false;
    this->y_cond_upper = false;
    this->size_cond_lower = false;
    this->size_cond_upper = false;
    this->time_cond_lower = false;
    this->time_cond_upper = false;
};
icCanvasManager::TileCache::TileCacheQuery::~TileCacheQuery() {};

void icCanvasManager::TileCache::TileCacheQuery::query_x_gte(int x_lower_bound) {
    this->x_lower = x_lower_bound;
    this->x_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_x_eq(int x_equals) {
    this->x_equals = x_equals;
    this->x_cond_equals = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_x_lt(int x_upper_bound) {
    this->x_upper = x_upper_bound;
    this->x_cond_upper = true;
};

void icCanvasManager::TileCache::TileCacheQuery::query_y_gte(int y_lower_bound) {
    this->y_lower = y_lower_bound;
    this->y_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_y_eq(int y_equals) {
    this->y_equals = y_equals;
    this->y_cond_equals = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_y_lt(int y_upper_bound) {
    this->y_upper = y_upper_bound;
    this->y_cond_upper = true;
};

void icCanvasManager::TileCache::TileCacheQuery::query_size_gte(int size_lower_bound) {
    this->size_lower = size_lower_bound;
    this->size_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_size_eq(int size_equals) {
    this->size_equals = size_equals;
    this->size_cond_equals = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_size_lt(int size_upper_bound) {
    this->size_upper = size_upper_bound;
    this->size_cond_upper = true;
};

void icCanvasManager::TileCache::TileCacheQuery::query_time_gte(int time_lower_bound) {
    this->time_lower = time_lower_bound;
    this->time_cond_lower = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_time_eq(int time_equals) {
    this->time_equals = time_equals;
    this->time_cond_equals = true;
};
void icCanvasManager::TileCache::TileCacheQuery::query_time_lt(int time_upper_bound) {
    this->time_upper = time_upper_bound;
    this->time_cond_upper = true;
};

int icCanvasManager::TileCache::getTreeIndex(int x, int y, int size) {
    int current_treenode_idx = 0;
    auto* current_treenode = &this->_quadtreeIndex.at(current_treenode_idx);
    int shiftX = x, shiftY = y, unshiftX = 0, unshiftY = 0;

    while (true) {
        if (current_treenode->x = x && current_treenode->y = y && current_treenode->size == size) {
            break; //Got an exact match
        }

        bool useTop, useLeft;

        useTop = shiftX & (UINT32_MAX & UINT32_MAX >> 1) != 0;
        useLeft = shiftY & (UINT32_MAX & UINT32_MAX >> 1) != 0;

        unshiftX = (unshiftX << 1) | (useTop ? 1 : 0);
        unshiftY = (unshiftY << 1) | (useLeft ? 1 : 0);

        shiftX = shiftX << 1;
        shiftY = shiftY << 1;

        int* next_treenode = NULL;

        if (useTop & useLeft) {
            next_treenode = &current_treenode->tl;
        } else if (useTop & !useLeft) {
            next_treenode = &current_treenode->tr;
        } else if (!useTop & useLeft) {
            next_treenode = &current_treenode->bl;
        } else if (!useTop & !useLeft) {
            next_treenode = &current_treenode->br;
        }

        if (*next_treenode == -1) {
            //Node missing. Create node.
            int nodeX = unshiftX << (31 - current_treenode->size),
                nodeY = unshiftY << (31 - current_treenode->size);

            icCanvasManager::TileCache::TileTree newNode = {nodeX, nodeY, current_treenode->size + 1, -1, -1, -1, -1, -1};
            *next_treenode = this->_quadtreeIndex.size();
            this->_quadtreeIndex.push_back(newNode);
        }

        //Navigate to new node.
        current_treenode_idx = *next_treenode;
    }

    return current_treenode_idx;
};

int icCanvasManager::TileCache::store(int x, int y, int size, int timeindex, cairo_surface_t* store) {
    icCanvasManager::TileCache::TileCacheQuery tquery;
    tquery.query_x_eq(x);
    tquery.query_y_eq(y);
    tquery.query_size_eq(size);
    tquery.query_time_eq(timeindex);

    std::vector<int> tids = this->execute(tquery);
    int the_tid;
    icCanvasManager::TileCache::Tile *tref = NULL;

    if (tids.size() > 0) {
        tref = &this->tile_at(tids.at(0));
        the_tid = tids.at(0);
    } else {
        the_tid = this->_storage.size();
        this->_storage.emplace_back();
        tref = &this->_storage.back();
        tref->image = NULL;
    }

    if (tref->image != NULL) cairo_surface_destroy(tref->image);
    *tref = {store, x, y, size, timeindex};
    cairo_surface_reference(store);

    std::pair<int, int> xindex_entry = {x, the_tid};
    std::pair<int, int> yindex_entry = {y, the_tid};
    std::pair<int, int> sizeindex_entry = {size, the_tid};
    std::pair<int, int> timeindex_entry = {timeindex, the_tid};

    this->_xIndex.insert(xindex_entry);
    this->_yIndex.insert(yindex_entry);
    this->_sizeIndex.insert(sizeindex_entry);
    this->_timeIndex.insert(timeindex_entry);

    //Update the quadtree index
    int qtIndexId = this->getTreeIndex(x, y, size);
    this->_quadtreeIndex.at(qtIndexId);

    return the_tid;
};

std::vector<int> icCanvasManager::TileCache::execute(icCanvasManager::TileCache::TileCacheQuery& query) {
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
    if (query.x_cond_upper) {
        xindex_end = this->_xIndex.upper_bound(query.x_upper);
    }
    if (query.x_cond_equals) {
        auto xindex_range = this->_xIndex.equal_range(query.x_equals);
        xindex_start = xindex_range.first;
        xindex_end = xindex_range.second;
    }

    if (query.y_cond_lower) {
        yindex_start = this->_yIndex.lower_bound(query.y_lower);
    }
    if (query.y_cond_upper) {
        yindex_end = this->_yIndex.upper_bound(query.y_upper);
    }
    if (query.y_cond_equals) {
        auto yindex_range = this->_xIndex.equal_range(query.y_equals);
        yindex_start = yindex_range.first;
        yindex_end = yindex_range.second;
    }

    if (query.size_cond_lower) {
        sizeindex_start = this->_sizeIndex.lower_bound(query.size_lower);
    }
    if (query.size_cond_upper) {
        sizeindex_end = this->_sizeIndex.upper_bound(query.size_upper);
    }
    if (query.size_cond_equals) {
        auto sizeindex_range = this->_xIndex.equal_range(query.size_equals);
        sizeindex_start = sizeindex_range.first;
        sizeindex_end = sizeindex_range.second;
    }

    if (query.time_cond_lower) {
        timeindex_start = this->_timeIndex.lower_bound(query.time_lower);
    }
    if (query.time_cond_upper) {
        timeindex_end = this->_timeIndex.upper_bound(query.time_upper);
    }
    if (query.time_cond_equals) {
        auto timeindex_range = this->_xIndex.equal_range(query.time_equals);
        timeindex_start = timeindex_range.first;
        timeindex_end = timeindex_range.second;
    }

    //TODO: Improve index selection, or find a way to count results

    std::vector<int> results;

    for (; xindex_start != xindex_end; xindex_start++) {
        if (query.y_cond_lower && this->_storage.at(xindex_start->second).y < query.y_lower) {
            continue;
        }

        if (query.y_cond_upper && this->_storage.at(xindex_start->second).y >= query.y_upper) {
            continue;
        }

        if (query.y_cond_equals && this->_storage.at(xindex_start->second).y != query.y_equals) {
            continue;
        }

        if (query.size_cond_lower && this->_storage.at(xindex_start->second).size < query.size_lower) {
            continue;
        }

        if (query.size_cond_upper && this->_storage.at(xindex_start->second).size >= query.size_upper) {
            continue;
        }

        if (query.size_cond_equals && this->_storage.at(xindex_start->second).size != query.size_equals) {
            continue;
        }

        if (query.time_cond_lower && this->_storage.at(xindex_start->second).time < query.time_lower) {
            continue;
        }

        if (query.time_cond_upper && this->_storage.at(xindex_start->second).time >= query.time_upper) {
            continue;
        }

        if (query.time_cond_equals && this->_storage.at(xindex_start->second).time != query.time_equals) {
            continue;
        }

        results.push_back(xindex_start->second);
    }

    return results;
};

int icCanvasManager::TileCache::lookup(int x, int y, int size, int timeindex) {
    auto timerange = this->_timeIndex.equal_range(timeindex);
    auto begin = timerange.first, end = timerange.second;

    for (; begin != end; begin++) {
        auto &tile = this->_storage.at(begin->second);
        if (tile.x == x && tile.y == y && tile.size == size) {
            return begin->second;
        }
    }

    return -1;
};

icCanvasManager::TileCache::Tile& icCanvasManager::TileCache::tile_at(int tileID) {
    return this->_storage.at(tileID);
};
