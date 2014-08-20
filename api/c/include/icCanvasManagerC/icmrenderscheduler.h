#ifndef __ICCANVASMANAGER_CAPI__ICM_RENDERSCHEDULER__H__
#define __ICCANVASMANAGER_CAPI__ICM_RENDERSCHEDULER__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void icm_renderscheduler;

    icm_renderscheduler* icm_drawing_construct();
    int icm_renderscheduler_reference(icm_renderscheduler *this);
    int icm_renderscheduler_dereference(icm_renderscheduler *this);

    void icm_renderscheduler_request_tile(icm_drawing *d, int x, int y, int size, int time);
    void icm_renderscheduler_revoke_request(icm_drawing *d, int x_min, int y_min, int x_max, int y_max);
    void icm_renderscheduler_background_tick();
    int icm_renderscheduler_collect_requests(icm_drawing *d);

#ifdef __cplusplus
}
#endif

#endif
