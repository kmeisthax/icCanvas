#ifndef __ICCANVASMANAGER_RENDERSCHEDULER_HPP_
#define __ICCANVASMANAGER_RENDERSCHEDULER_HPP_

namespace icCanvasManager {
    /* RenderScheduler handles the rendering of tiles to off-screen surfaces.
     *
     * The Scheduler is free to render by any means necessary, including async
     * or off-thread methods.
     *
     * The main thread puts requests into the Scheduler, and then collects them
     * periodically to fill a TileCache with rendered tiles.
     */
    class RenderScheduler : public RefCnt {
    public:
        RenderScheduler();
        ~RenderScheduler();

        /* Put a request for a tile to be rendered. */
        request_tile(RefPtr<Drawing> d, int x, int y, int size, int time);

        /* Collect fulfilled requests.
         *
         * Since a RenderScheduler can be responsible for rendering more than
         * one drawing at a time, you must collect each drawing's tiles
         * individually.
         */
        collect_requests(RefPtr<Drawing> d, RefPtr<TileCache> tcache);
    }
}

#endif
