#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_renderscheduler* icm_drawing_construct() {
        icCanvasManager::RenderScheduler* d = new icCanvasManager::RenderScheduler();
        d->ref();

        return (icm_drawing*)d;
    };

    int icm_renderscheduler_reference(icm_renderscheduler *this) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        return d->ref();
    };

    int icm_renderscheduler_dereference(icm_renderscheduler *this) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        int refcount = d->unref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    void icm_renderscheduler_request_tile(icm_drawing *d, int x, int y, int size, int time) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        d->request_tile(x, y, size, time);
    };

    void icm_renderscheduler_revoke_request(icm_drawing *d, int x_min, int y_min, int x_max, int y_max) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        d->revoke_request(x_min, y_min, x_max, y_max);
    };

    void icm_renderscheduler_background_tick() {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        d->background_tick();
    };

    int icm_renderscheduler_collect_requests(icm_drawing *d) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        return d->collect_requests();
    };
}
