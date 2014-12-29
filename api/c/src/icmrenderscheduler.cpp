#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_renderscheduler icm_renderscheduler_construct() {
        icCanvasManager::RenderScheduler* d = new icCanvasManager::RenderScheduler();
        d->ref();

        return (icm_renderscheduler)d;
    };

    icm_renderscheduler icm_renderscheduler_reference(icm_renderscheduler w) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        d->ref();

        return w;
    };

    int icm_renderscheduler_dereference(icm_renderscheduler w) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    void icm_renderscheduler_request_tile(icm_renderscheduler w, icm_drawing d, int x, int y, int size, int time) {
        icCanvasManager::RenderScheduler* theSched = (icCanvasManager::RenderScheduler*)w;
        icCanvasManager::Drawing* theDrawing = (icCanvasManager::Drawing*)d;
        theSched->request_tile(theDrawing, x, y, size, time);
    };

    void icm_renderscheduler_request_tiles(icm_renderscheduler w, icm_drawing d, cairo_rectangle_t *rect, int size, int time) {
        icCanvasManager::RenderScheduler* theSched = (icCanvasManager::RenderScheduler*)w;
        icCanvasManager::Drawing* theDrawing = (icCanvasManager::Drawing*)d;

        cairo_rectangle_t loco_rect = *rect;

        theSched->request_tiles(theDrawing, loco_rect, size, time);
    };

    void icm_renderscheduler_revoke_request(icm_renderscheduler w, icm_drawing d, int x_min, int y_min, int x_max, int y_max) {
        icCanvasManager::RenderScheduler* theSched = (icCanvasManager::RenderScheduler*)w;
        icCanvasManager::Drawing* theDrawing = (icCanvasManager::Drawing*)d;
        theSched->revoke_request(theDrawing, x_min, y_min, x_max, y_max);
    };

    void icm_renderscheduler_background_tick(icm_renderscheduler w) {
        icCanvasManager::RenderScheduler* d = (icCanvasManager::RenderScheduler*)w;
        d->background_tick();
    };

    int icm_renderscheduler_collect_request(icm_renderscheduler w, icm_drawing d, cairo_rectangle_t* out_tile_rect) {
        icCanvasManager::RenderScheduler* theSched = (icCanvasManager::RenderScheduler*)w;
        icCanvasManager::Drawing* theDrawing = (icCanvasManager::Drawing*)d;
        return theSched->collect_request(theDrawing, out_tile_rect);
    };
}
