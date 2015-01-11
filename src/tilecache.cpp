#include <icCanvasManager.hpp>

icCanvasManager::TileCache::TileCache() {
    icCanvasManager::TileCache::TileTree root = {0, 0, 0, -1, -1, -1, -1, -1};
    this->_quadtreeIndex.push_back(root);
};
icCanvasManager::TileCache::~TileCache() {};

icCanvasManager::TileCache::TileCacheQuery::TileCacheQuery() {
    this->x_cond_lower = false;
    this->x_cond_upper = false;
    this->x_cond_equals = false;
    this->y_cond_lower = false;
    this->y_cond_upper = false;
    this->y_cond_equals = false;
    this->size_cond_lower = false;
    this->size_cond_upper = false;
    this->size_cond_equals = false;
    this->time_cond_lower = false;
    this->time_cond_upper = false;
    this->time_cond_equals = false;
    this->time_cond_limit = false;
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

void icCanvasManager::TileCache::TileCacheQuery::query_time_limit(int time_limit) {
    this->time_limit = time_limit;
    this->time_cond_limit = true;
};

int icCanvasManager::TileCache::getTreeIndex(int x, int y, int size) {
    unsigned int size_mask = UINT32_MAX >> size;

    assert((x & (size_mask >> 1)) == 0);
    assert((y & (size_mask >> 1)) == 0);
    assert(size < 32);

    int current_treenode_idx = 0;
    auto* current_treenode = &this->_quadtreeIndex.at(current_treenode_idx);

    while (true) {
        assert(current_treenode->size < 32);
        if (current_treenode->x == x && current_treenode->y == y && current_treenode->size == size) {
            break; //Got an exact match
        }

        bool useRight = x > current_treenode->x,
             useBottom = y > current_treenode->y;

        unsigned int next_size_mask = UINT32_MAX >> (current_treenode->size + 1);
        int xdelta = (next_size_mask / 2 + 1) * (useRight ? 1 : -1),
            ydelta = (next_size_mask / 2 + 1) * (useBottom ? 1 : -1),
            nodeX = current_treenode->x + xdelta,
            nodeY = current_treenode->y + ydelta;

        int* next_treenode = NULL;

        if (useBottom && useRight) {
            next_treenode = &current_treenode->br;
        } else if (useBottom && !useRight) {
            next_treenode = &current_treenode->bl;
        } else if (!useBottom && useRight) {
            next_treenode = &current_treenode->tr;
        } else if (!useBottom && !useRight) {
            next_treenode = &current_treenode->tl;
        } else {
            assert(false); // WTF BOOOM
        }

        assert(next_treenode != NULL);

        if (*next_treenode < 0) {
            //Node missing. Create node.
            icCanvasManager::TileCache::TileTree newNode = {nodeX, nodeY, current_treenode->size + 1, -1, -1, -1, -1, -1};
            current_treenode_idx = (int)this->_quadtreeIndex.size();
            *next_treenode = current_treenode_idx;
            this->_quadtreeIndex.push_back(newNode);
        } else {
            current_treenode_idx = *next_treenode;
        }

        //Navigate to new node.
        current_treenode = &this->_quadtreeIndex.at(current_treenode_idx);

        assert(current_treenode->x == nodeX);
        assert(current_treenode->y == nodeY);
    }

    return current_treenode_idx;
};

int icCanvasManager::TileCache::store(int x, int y, int size, int timeindex, cairo_surface_t* store) {
    int qtIndexId = this->getTreeIndex(x, y, size);
    auto& treeRef = this->_quadtreeIndex.at(qtIndexId);
    int the_tid = treeRef.tindex, future_tid = -1, new_tid = -1;
    icCanvasManager::TileCache::Tile *tref = NULL, *future_tref = NULL, *new_tref = NULL;

    if (the_tid == -1) {
        //No tile exists at this point.
        new_tid = this->_storage.size();
        this->_storage.emplace_back();

        new_tref = &this->_storage.back();
        *new_tref = {store, x, y, size, timeindex, future_tid, -1};

        treeRef.tindex = new_tid;

        return new_tid;
    }

    tref = &this->_storage.at(the_tid);

    while (tref->time > timeindex && tref->time_future != -1) {
        the_tid = tref->time_future;
        tref = &this->_storage.at(the_tid);
    }

    if (tref->time == timeindex) {
        //Reuse existing Tile
        if (tref->image != NULL) cairo_surface_destroy(tref->image);
        tref->image = store;
        cairo_surface_reference(store);

        return the_tid;
    }

    //Place Tile as future of tref
    future_tid = tref->time_future;
    if (future_tid != -1) future_tref = &this->_storage.at(future_tid);

    new_tid = this->_storage.size();
    if (future_tid != -1) future_tref->time_past = new_tid;
    else treeRef.tindex = new_tid;
    tref->time_future = new_tid;

    this->_storage.emplace_back();
    new_tref = &this->_storage.back();
    *new_tref = {store, x, y, size, timeindex, future_tid, the_tid};
    cairo_surface_reference(store);

    return new_tid;
};

std::vector<int> icCanvasManager::TileCache::execute(icCanvasManager::TileCache::TileCacheQuery& query) {
    int minimum_quadtree_level = 0, maximum_quadtree_level = 32;
    int minimum_time = -1, maximum_time = INT32_MAX, time_limit = INT32_MAX;
    int visrect_x_min = INT32_MIN, visrect_y_min = INT32_MIN,
        visrect_x_max = INT32_MAX, visrect_y_max = INT32_MAX;

    //Flatten the queryinfo
    if (query.x_cond_lower) visrect_x_min = query.x_lower;
    if (query.x_cond_upper) visrect_x_max = query.x_upper;
    if (query.x_cond_equals) {
        visrect_x_min = query.x_lower;
        visrect_x_max = query.x_upper + 1;
    }

    if (query.y_cond_lower) visrect_y_min = query.y_lower;
    if (query.y_cond_upper) visrect_y_max = query.y_upper;
    if (query.y_cond_equals) {
        visrect_y_min = query.y_lower;
        visrect_y_max = query.y_upper + 1;
    }

    if (query.size_cond_lower) minimum_quadtree_level = query.size_lower;
    if (query.size_cond_upper) maximum_quadtree_level = query.size_upper;
    if (query.size_cond_equals) {
        minimum_quadtree_level = query.size_equals;
        maximum_quadtree_level = query.size_equals + 1;
    }

    if (query.time_cond_lower) minimum_time = query.time_lower;
    if (query.time_cond_upper) maximum_time = query.time_upper;
    if (query.time_cond_equals) {
        minimum_time = query.time_equals;
        maximum_time = query.time_equals + 1;
    }
    if (query.time_cond_limit) time_limit = query.time_limit;

    int current_level_size = 0;
    std::vector<int> current_level, current_level_timemin, next_level, next_level_timemin;
    std::vector<int> results;

    current_level.push_back(0);
    current_level_timemin.push_back(minimum_time);

    //Walk the quadtree index.
    while (current_level_size < maximum_quadtree_level) {
        //Expand query rectangle to the next level's tile size
        long long int tile_size = UINT32_MAX >> (current_level_size + 1);
        long long int nexvrect_x_min = visrect_x_min - tile_size,
            nexvrect_y_min = visrect_y_min - tile_size,
            nexvrect_x_max = visrect_x_max + tile_size,
            nexvrect_y_max = visrect_y_max + tile_size;

        //Walk each tile in current_level
        auto i = current_level.begin();
        for (auto j = current_level_timemin.begin();
                  i != current_level.end() && j != current_level_timemin.end();
                  i++, j++) {
            //If within the query rectangle, fill next_level with child treenodes
            auto& current_treenode = this->_quadtreeIndex.at(*i);
            int next_timemin = *j;
            if (current_level_size >= minimum_quadtree_level && current_treenode.tindex != -1) {
                next_timemin = std::max(*j, this->_storage.at(current_treenode.tindex).time);
            }

            if (current_treenode.tl != -1) {
                auto& tl = this->_quadtreeIndex.at(current_treenode.tl);
                if (nexvrect_x_min <= tl.x && tl.x < nexvrect_x_max &&
                    nexvrect_y_min <= tl.y && tl.y < nexvrect_y_max) {
                    next_level.push_back(current_treenode.tl);
                    next_level_timemin.push_back(next_timemin);
                }
            }

            if (current_treenode.tr != -1) {
                auto& tr = this->_quadtreeIndex.at(current_treenode.tr);
                if (nexvrect_x_min <= tr.x && tr.x < nexvrect_x_max &&
                    nexvrect_y_min <= tr.y && tr.y < nexvrect_y_max) {
                    next_level.push_back(current_treenode.tr);
                    next_level_timemin.push_back(next_timemin);
                }
            }

            if (current_treenode.bl != -1) {
                auto& bl = this->_quadtreeIndex.at(current_treenode.bl);
                if (nexvrect_x_min <= bl.x && bl.x < nexvrect_x_max &&
                    nexvrect_y_min <= bl.y && bl.y < nexvrect_y_max) {
                    next_level.push_back(current_treenode.bl);
                    next_level_timemin.push_back(next_timemin);
                }
            }

            if (current_treenode.br != -1) {
                auto& br = this->_quadtreeIndex.at(current_treenode.br);
                if (nexvrect_x_min <= br.x && br.x < nexvrect_x_max &&
                    nexvrect_y_min <= br.y && br.y < nexvrect_y_max) {
                    next_level.push_back(current_treenode.br);
                    next_level_timemin.push_back(next_timemin);
                }
            }

            //If within the size requirements, fill results with current level tiles
            if (current_level_size >= minimum_quadtree_level && current_treenode.tindex != -1) {
                int current_time_tile = current_treenode.tindex;
                int found_tiles = 0;

                while (found_tiles < time_limit) {
                    auto& tile = this->_storage.at(current_time_tile);
                    auto effective_tmin = *j;

                    if (effective_tmin <= tile.time && tile.time < maximum_time) {
                        results.push_back(current_time_tile);
                        found_tiles++;
                    } else if (tile.time >= maximum_time) {
                        //Tile time list is sorted, so don't scan through tiles known to be dead
                        break;
                    }

                    if (tile.time_past != -1) {
                        current_time_tile = tile.time_past;
                    } else {
                        break;
                    }
                }
            }
        }

        //Enter the next level of the quadtree.
        current_level = next_level;
        current_level_timemin = next_level_timemin;
        current_level_size++;
        next_level.clear();
        next_level_timemin.clear();
    }

    return results;
};

int icCanvasManager::TileCache::lookup(int x, int y, int size, int timeindex) {
    int treeIndex = this->getTreeIndex(x, y, size);
    auto &treeNode = this->_quadtreeIndex.at(treeIndex);

    if (treeNode.tindex == -1) return -1;

    int currentTileIdx = treeNode.tindex;

    while (currentTileIdx != -1) {
        auto &currentTile = this->_storage.at(currentTileIdx);

        if (currentTile.time == timeindex) return currentTileIdx;
        if (currentTile.time < timeindex) return -1;

        currentTileIdx = currentTile.time_past;
    }

    return -1;
};

icCanvasManager::TileCache::Tile& icCanvasManager::TileCache::tile_at(int tileID) {
    return this->_storage.at(tileID);
};
