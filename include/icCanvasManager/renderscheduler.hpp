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
        struct __Request {
            Drawing* d;
            int x, y, size, time;
        };

        struct __Response {
            Drawing* d;
            int x, y, size, time;
            cairo_surface_t* tile;
        };

        std::vector<__Request> _unrendered;
        std::vector<__Response> _uncollected;
        RefPtr<Renderer> _renderer;
    public:
        RenderScheduler();
        ~RenderScheduler();

        /* Put a request for a tile to be rendered. */
        void request_tile(RefPtr<Drawing> d, int x, int y, int size, int time);

        /* Revoke previously made requests in a particular canvas rectangle.
         *
         * Already filled requests (or those currently in processing) cannot be
         * revoked and will reach the TileCache anyway.
         */
        void revoke_request(RefPtr<Drawing> d, int x_min, y_min, x_max, y_max);

        /* Process rendering tasks whenever the application has free time.
         *
         * This function is specifically designed to be called periodically and
         * takes a very small amount of time to execute. Call it whenever.
         */
        void background_tick();

        /* Collect fulfilled requests into a drawing's TileCache.
         *
         * Since a RenderScheduler can be responsible for rendering more than
         * one drawing at a time, you must collect each drawing's tiles
         * individually.
         *
         * You should call this method periodically (ideally, before querying
         * a drawing's tile cache) in order to ensure completed renders hit the
         * drawing's tile cache.
         *
         * Returns number of tiles collected - 0 if none were rendered.
         */
        int collect_requests(RefPtr<Drawing> d);
    };
}

#endif
