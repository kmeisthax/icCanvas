#ifndef __ICCANVASMANAGER_SPLINEFITTER_HPP_
#define __ICCANVASMANAGER_SPLINEFITTER_HPP_

#include "../icCanvasManager.hpp"

namespace icCanvasManager {
    /* Stores pre-drawn tiles for later display.
     *
     * Tiles are indexed by centroid X/Y position, the zoom level, and time
     * index. X/Y positions must not overlap with other tiles at the same zoom
     * level and time index.
     */
    class TileCache : public RefCnt {
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
         */
        void store(int x, int y, int size, int timeindex, cairo_surface_t* store);

        /* Retrieve a particular tile from the tilecache.
         *
         * The returned Cairo surface will always be an image surface of size
         * TILE_SIZE.
         *
         * Do not draw onto the returned surface.
         *
         * NULL will be returned if the particular tile surface does not exist,
         * in which case you should probably render it and store it here.
         *
         * You can search by time index. The timeindex_after property lets you
         * select tiles with a time index greater than or equal to the one
         * specified. The timeindex_before property lets you select tiles with
         * a time index less than the one specified. A negative time index
         * indicates a "don't care", e.g. the condition will not be tested.
         *
         * In the event that more than one tile satisfies positional, size, and
         * time requirements, lookup will return any one of the tiles at random
         * (i.e. the behavior is undefined beyond "you will get ONE tile".) If
         * you specify a non-NULL pointer to out_timeindex, lookup will tell
         * you the time index of the tile you recieved.
         */
        cairo_surface_t* lookup(int x, int y, int size, int timeindex_after = -1, int timeindex_before = -1, int* out_timeindex = NULL);
    }
}

#endif
