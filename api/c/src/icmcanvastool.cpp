#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_canvastool icm_canvastool_reference(icm_canvastool w) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        d->ref();

        return w;
    };

    int icm_canvastool_dereference(icm_canvastool w) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    void icm_canvastool_prepare_for_reuse(icm_canvastool w) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        d->prepare_for_reuse();
    };

    void icm_canvastool_set_size(icm_canvastool w, const double width, const double height, const double ui_scale, const double zoom) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        d->set_size(width, height, ui_scale, zoom);
    };

    void icm_canvastool_set_scroll_center(icm_canvastool w, const double x, const double y) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        d->set_scroll_center(x,y);
    };

    void icm_canvastool_mouse_down(icm_canvastool w, const double x, const double y, const double deltaX, const double deltaY) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        d->mouse_down(x, y, deltaX, deltaY);
    };

    void icm_canvastool_mouse_drag(icm_canvastool w, const double x, const double y, const double deltaX, const double deltaY) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        d->mouse_drag(x, y, deltaX, deltaY);
    };

    void icm_canvastool_mouse_up(icm_canvastool w, const double x, const double y, const double deltaX, const double deltaY) {
        icCanvasManager::CanvasTool* d = (icCanvasManager::CanvasTool*)w;
        d->mouse_up(x, y, deltaX, deltaY);
    };
}
