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
        static const int TILE_SIZE = 256;

        /* TileData is generically stored as an array of TILE_SIZExTILE_SIZE
         * floats, with each pixel stored in RGBA order, all floats within
         * the range [0.0, 1.0], and all pixels have premultiplied alpha.
         */
        typedef float (*TileData)[TILE_SIZE][4]; //BOLLOCKS

        struct TileTree;

        struct Tile {
            //Pointer to rendered tile(s). (May be NULL)
            DisplaySuiteTILE current_tile;

            //Authoritative information about this tile.
            int x, y, size, time;

            //Index of future and past tiles.
            // -1 indicates NULL.
            int time_future, time_past;
        };

        struct TileTree {
            int x, y, size;

            int tindex; //Index of latest tile at this x, y, and size. If negative, not rendered

            int tl, tr, bl, br; //Next level tiletree indexes.
                                //-1 if that node of the tree does not exist.
        };

        class TileCacheQuery : public RefCnt {
            int x_lower, x_upper, x_equals,
                y_lower, y_upper, y_equals,
                size_lower, size_upper, size_equals,
                time_lower, time_upper, time_equals, time_limit;
            bool x_cond_lower, x_cond_upper, x_cond_equals,
                 y_cond_lower, y_cond_upper, y_cond_equals,
                 size_cond_lower, size_cond_upper, size_cond_equals,
                 time_cond_lower, time_cond_upper, time_cond_equals, time_cond_limit;

        public:
            TileCacheQuery();
            virtual ~TileCacheQuery();

            /* Query by coordinates.
             *
             * Only tiles which intersect the rectangle specified here will be
             * returned. Tiles do not need to intersect the full range of the
             * rectangle.
             */
            void query_x_gte(int x_lower_bound);
            void query_x_eq(int x_equals);
            void query_x_lt(int x_higher_bound);
            void query_y_gte(int y_lower_bound);
            void query_y_eq(int y_equals);
            void query_y_lt(int y_higher_bound);

            /* Query by size.
             *
             * Only tiles which meet the specified size requirements will be
             * returned. Tiles will always be returned largest-first, so that
             * rendering them in order will produce the best result.
             */
            void query_size_gte(int size_lower_bound);
            void query_size_eq(int size_equals);
            void query_size_lt(int size_higher_bound);

            /* Query by time.
             *
             * Only tiles which were created to represent times within a
             * particular range of drawing time will be returned. Tiles will
             * be returned sorted latest-tile-first.
             *
             * You can also restrict how many versions of each tile are
             * returned. This is, again, subject to existing time index query
             * requirements, so for example a time limit of 2 will return, from
             * within the timing range specified, up to 2 tiles.
             */
            void query_time_gte(int time_lower_bound);
            void query_time_eq(int time_equals);
            void query_time_lt(int time_higher_bound);
            void query_time_limit(int time_limit);

            friend TileCache;
        };
    private:
        std::vector<Tile> _storage;
        std::vector<TileTree> _quadtreeIndex;

        RefPtr<DisplaySuite> _currentSuite;

        /* Given a coordinate and size, find what index into the quadtree index
         * corresponds to the particular location.
         *
         * May create new quadtree nodes.
         */
        int getTreeIndex(int x, int y, int size);
    public:
        TileCache();
        virtual ~TileCache();

        DisplaySuite* display_suite();

        /* Select a DisplaySuite to store tiles for.
         *
         * If a DisplaySuite has already been selected, selecting a different
         * non-NULL suite will cause all existing tiles to be transferred into
         * the preferred representation of the new DisplaySuite.
         *
         * Selecting a NULL suite will cause all tile data to be deleted, but
         * the existing indexes into the cache will remain.
         *
         * The TileCache's other methods cannot be used without a working
         * DisplaySuite.
         */
        void set_display_suite(DisplaySuite* s);

        /* Store a tile into the tile cache.
         *
         * The given DisplaySuite tile will be owned by the TileCache and
         * should not be drawn upon by any Renderer(s).
         *
         * If a tile of the same position, size, and timeindex already exists
         * in this cache, the incoming tile will replace it and the existing
         * tile will be freed.
         *
         * The ID of the resulting tilecache tile is stored.
         */
        int store(int x, int y, int size, int timeindex, DisplaySuiteTILE store);

        /* Retrieve a range of tiles from the tilecache.
         *
         * The input is a TileCacheQuery, which allows you to query by x/y
         * position, size, and time, in both less-than and greater-than forms.
         * The meanings of those parameters are specified in TileCacheQuery.
         *
         * Results of executing a query are returned as a list of Tile IDs.
         * They will be sorted by size (e.g. larger tiles before smaller) such
         * that rendering them in order will produce the correct result.
         */
        std::vector<int> execute(TileCacheQuery& query);

        /* Retrieve an exact tile from the tilecache.
         *
         * For consistency's sake we return an index into the tilecache
         * much like the execute function.
         */
        int lookup(int x, int y, int size, int timeindex);

        /* Return a reference to the Tile structure known by a particular ID.
         *
         * Do not alter the contents of the Tile as it may invalidate the
         * tilecache indexes.
         */
        Tile& tile_at(int tileID);
    };
}

#endif
