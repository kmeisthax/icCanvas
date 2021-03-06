#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_canvasview icm_canvasview_construct() {
        icCanvasManager::CanvasView* d = new icCanvasManager::CanvasView();
        d->ref();

        return (icm_canvasview)d;
    };

    icm_canvasview icm_canvasview_reference(icm_canvasview w) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->ref();

        return w;
    };

    int icm_canvasview_dereference(icm_canvasview w) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    void icm_canvasview_attach_drawing(icm_canvasview w, icm_drawing drawing) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        icCanvasManager::Drawing* theDrawing = (icCanvasManager::Drawing*)drawing;

        d->attach_drawing(theDrawing);
    };

    void icm_canvasview_draw(icm_canvasview w, cairo_t *ctxt, cairo_rectangle_list_t *rectList) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->draw(ctxt, rectList);
    };

    void icm_canvasview_set_size(icm_canvasview w, const double width, const double height, const double ui_scale) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->set_size(width, height, ui_scale);
    };

    void icm_canvasview_set_size_default(icm_canvasview w, const double ui_scale) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->set_size(ui_scale);
    };

    void icm_canvasview_set_ui_scale(icm_canvasview w, const double ui_scale) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->set_ui_scale(ui_scale);
    };

    void icm_canvasview_get_size(icm_canvasview w, double *out_width, double *out_height, double *out_ui_scale) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->get_size(out_width, out_height, out_ui_scale);
    };

    void icm_canvasview_get_maximum_size(icm_canvasview w, double *out_width, double *out_height) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->get_maximum_size(out_width, out_height);
    };

    void icm_canvasview_get_scale_extents(icm_canvasview w, double *out_minscale, double *out_maxscale) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->get_scale_extents(out_minscale, out_maxscale);
    };

    void icm_canvasview_set_scroll_center(icm_canvasview w, const double x, const double y) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->set_scroll_center(x, y);
    };

    void icm_canvasview_set_zoom(icm_canvasview w, const double vpixel_size) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        d->set_zoom(vpixel_size);
    };

    double icm_canvasview_get_zoom(icm_canvasview w) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        return d->get_zoom();
    };

    int icm_canvasview_highest_zoom(icm_canvasview w) {
        icCanvasManager::CanvasView* d = (icCanvasManager::CanvasView*)w;
        return d->highest_zoom();
    };
}
