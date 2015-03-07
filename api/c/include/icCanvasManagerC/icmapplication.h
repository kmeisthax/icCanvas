#ifndef __ICCANVASMANAGER_CAPI__ICM_APPLICATION__H__
#define __ICCANVASMANAGER_CAPI__ICM_APPLICATION__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void *icm_application;

    typedef void *icm_renderscheduler;

    icm_application icm_application_get_instance();

    icm_application icm_application_reference(icm_application wrap);
    int icm_application_dereference(icm_application wrap);

    void icm_application_background_tick(icm_application wrap);
    icm_renderscheduler icm_application_get_render_scheduler(icm_application wrap);

#ifdef __cplusplus
}
#endif

#endif
