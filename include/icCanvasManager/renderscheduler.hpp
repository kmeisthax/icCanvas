#ifndef __ICCANVASMANAGER_RENDERSCHEDULER_HPP_
#define __ICCANVASMANAGER_RENDERSCHEDULER_HPP_

#include <icCanvasManager.hpp>

#include <cairo.h>

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
        struct __Response {
            Drawing* d;
            int x, y, size, time;
            cairo_surface_t* tile;
        }

        std::vector<__Response> _uncollected;
        RefCnt<Renderer> _renderer;
    public:
        RenderScheduler();
        ~RenderScheduler();

        /* Put a request for a tile to be rendered. */
        request_tile(RefPtr<Drawing> d, int x, int y, int size, int time);

        /* Collect fulfilled requests into a drawing's TileCache.
         *
         * Since a RenderScheduler can be responsible for rendering more than
         * one drawing at a time, you must collect each drawing's tiles
         * individually.
         *
         * You should call this method periodically as the implementation of
         * RenderScheduler is allowed to complete rendering asynchronously, or
         * even concurrently with the execution of the main thread. Ideally,
         * you should collect requests right before each draw operation.
         */
        collect_requests(RefPtr<Drawing> d);
    }
}

#endif
