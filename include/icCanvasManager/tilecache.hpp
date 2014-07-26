#ifndef __ICCANVASMANAGER_TILECACHE_HPP_
#define __ICCANVASMANAGER_TILECACHE_HPP_

#include "../icCanvasManager.hpp"

#include <map>
#include <tuple>

namespace icCanvasManager {
    /* Stores pre-drawn tiles for later display.
     *
     * Tiles are indexed by centroid X/Y position, the zoom level, and time
     * index. X/Y positions must not overlap with other tiles at the same zoom
     * level and time index.
     */
    class TileCache : public RefCnt {
    public:
        struct Tile {
            cairo_surface_t* image,
            int x, y, size, time;
        }

        class TileCacheQuery : public RefCnt {
            int x_lower, x_higher,
                y_lower, y_higher,
                size_lower, size_higher,
                time_lower, time_higher;
            bool x_cond_lower, x_cond_higher,
                 y_cond_lower, y_cond_higher,
                 size_cond_lower, size_cond_higher,
                 time_cond_lower, time_cond_higher;

        public:
            TileCacheQuery();
            virtual ~TileCacheQuery();

            void query_x_gte(int x_lower_bound);
            void query_x_eq(int x_equals);
            void query_x_lt(int x_higher_bound);

            void query_y_gte(int y_lower_bound);
            void query_y_eq(int y_equals);
            void query_y_lt(int y_higher_bound);

            void query_size_gte(int size_lower_bound);
            void query_size_eq(int size_equals);
            void query_size_lt(int size_higher_bound);

            void query_time_gte(int time_lower_bound);
            void query_time_eq(int time_equals);
            void query_time_lt(int time_higher_bound);

            friend TileCache;
        }
    private:
        std::vector<Tile> _storage;

        /* Tiles are indexed by std::map.
         *
         * The key is the integer value of the index, while the value is an
         * index into the _storage array.
         */
        typedef std::multimap<int, int> __IntIndex;

        __IntIndex _xIndex, _yIndex, _sizeIndex, _timeIndex;
    public:
        const int TILE_SIZE = 256;

        TileCache();
        virtual ~TileCache();

        /* Store a tile into the tile cache.
         *
         * The given Cairo surface must be an image surface of size TILE_SIZE
         * and no other size. It will be retained by the TileCache.
         *
         * Do not draw onto stored surfaces.
         *
         * If a surface of the same position, size, and timeindex already
         * exists, it will be supplanted by the incoming index.
         *
         * The ID of the resulting tilecache tile is stored.
         */
        int store(int x, int y, int size, int timeindex, cairo_surface_t* store);

        /* Retrieve a particular tile from the tilecache.
         *
         * The input is a TileCacheQuery, which allows you to query by x/y
         * position, size, and time, in both less-than and greater-than forms.
         *
         * Results of executing a query are returned as a list of Tile IDs.
         */
        std::vector<int> execute(TileCacheQuery& query);

        /* Return a reference to the Tile structure known by a particular ID.
         *
         * Do not alter the contents of the Tile as it may invalidate the
         * tilecache indexes.
         */
        Tile& tile_at(int tileID);
    }
}

#endif