#ifndef __ICCANVASMANAGER_CAPI__ICM_CANVASVIEW__H__
#define __ICCANVASMANAGER_CAPI__ICM_CANVASVIEW__H__

#include <icCanvasManagerC.h>

#include <cairo.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void *icm_canvasview;

    icm_drawing icm_canvasview_construct();
    int icm_canvasview_reference(icm_canvasview wrap);
    int icm_canvasview_dereference(icm_canvasview wrap);

    void icm_canvasview_attach_drawing(icm_canvasview wrap, icm_drawing drawing);
    void icm_canvasview_draw(icm_canvasview wrap, cairo_t *ctxt, cairo_rectangle_list_t *rectList);
    void icm_canvasview_set_size(icm_canvasview wrap, const double width, const double height, const double ui_scale);
    void icm_canvasview_set_size_default(icm_canvasview wrap, const double ui_scale);
    void icm_canvasview_get_size(icm_canvasview wrap, double *out_width, double *out_height, double *out_ui_scale);
    void icm_canvasview_get_maximum_size(icm_canvasview wrap, double *out_maxwidth, double *out_maxheight);
    void icm_canvasview_set_scroll_center(icm_canvasview wrap, const double x, const double y);
    void icm_canvasview_set_zoom(icm_canvasview wrap, const double vpixel_size);

    void icm_canvasview_mouse_down(icm_canvasview wrap, const double x, const double y, const double deltaX, const double deltaY);
    void icm_canvasview_mouse_drag(icm_canvasview wrap, const double x, const double y, const double deltaX, const double deltaY);
    void icm_canvasview_mouse_up(icm_canvasview wrap, const double x, const double y, const double deltaX, const double deltaY);

#ifdef __cplusplus
}
#endif

#endif
