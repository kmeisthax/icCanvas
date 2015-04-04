#ifndef __ICCANVASMANAGER_CAPI__ICM_RENDERER__H__
#define __ICCANVASMANAGER_CAPI__ICM_RENDERER__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_renderer;

    icm_renderer icm_renderer_construct();
    icm_renderer icm_renderer_reference(icm_renderer wrap);
    int icm_renderer_dereference(icm_renderer wrap);

#ifdef __cplusplus
}
#endif

#endif
