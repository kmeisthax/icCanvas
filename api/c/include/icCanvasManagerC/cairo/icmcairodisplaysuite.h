#ifndef __ICCANVASMANAGER_CAPI__ICM_CAIRO_DISPLAYSUITE__H__
#define __ICCANVASMANAGER_CAPI__ICM_CAIRO_DISPLAYSUITE__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_cairo_displaysuite;

    icm_cairo_displaysuite icm_cairo_displaysuite_construct();
    icm_cairo_displaysuite icm_cairo_displaysuite_reference(icm_cairo_displaysuite wrap);
    int icm_cairo_displaysuite_dereference(icm_cairo_displaysuite wrap);

    icm_cairo_displaysuite icm_cairo_displaysuite_downcast(icm_displaysuite up_obj);
    icm_displaysuite icm_cairo_displaysuite_upcast(icm_cairo_displaysuite down_obj);

#ifdef __cplusplus
}
#endif

#endif
