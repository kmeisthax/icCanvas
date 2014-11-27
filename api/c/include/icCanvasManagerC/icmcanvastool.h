#ifndef __ICCANVASMANAGER_CAPI__ICM_CANVASTOOL__H__
#define __ICCANVASMANAGER_CAPI__ICM_CANVASTOOL__H__

#include <icCanvasManagerC.h>

#include <cairo.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void *icm_canvastool;

    //No constructor for icm_canvastool; seek out it's various subclasses.
    int icm_canvastool_reference(icm_canvastool wrap);
    int icm_canvastool_dereference(icm_canvastool wrap);

    void icm_canvastool_prepare_for_reuse(icm_canvastool wrap);
    void icm_canvastool_set_size(icm_canvastool wrap, const double width, const double height, const double ui_scale, const double zoom);
    void icm_canvastool_set_scroll_center(icm_canvastool wrap, const double x, const double y);

    void icm_canvastool_mouse_down(icm_canvastool wrap, const double x, const double y, const double deltaX, const double deltaY);
    void icm_canvastool_mouse_drag(icm_canvastool wrap, const double x, const double y, const double deltaX, const double deltaY);
    void icm_canvastool_mouse_up(icm_canvastool wrap, const double x, const double y, const double deltaX, const double deltaY);

#ifdef __cplusplus
}
#endif

#endif
