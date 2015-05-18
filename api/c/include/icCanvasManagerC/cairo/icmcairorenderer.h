#ifndef __ICCANVASMANAGER_CAPI__ICM_CAIRO_RENDERER__H__
#define __ICCANVASMANAGER_CAPI__ICM_CAIRO_RENDERER__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_cairo_renderer;

    icm_cairo_renderer icm_cairo_renderer_construct();
    icm_cairo_renderer icm_cairo_renderer_reference(icm_cairo_renderer wrap);
    int icm_cairo_renderer_dereference(icm_cairo_renderer wrap);

    icm_cairo_renderer icm_cairo_renderer_downcast(icm_renderer up_obj);
    icm_renderer icm_cairo_renderer_upcast(icm_cairo_renderer down_obj);

#ifdef __cplusplus
}
#endif

#endif
