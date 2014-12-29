#ifndef __ICCANVASMANAGER_CAPI__ICM_RENDERSCHEDULER__H__
#define __ICCANVASMANAGER_CAPI__ICM_RENDERSCHEDULER__H__

#include <icCanvasManagerC.h>

#include <cairo.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void *icm_renderscheduler;

    icm_renderscheduler icm_renderscheduler_construct();
    icm_renderscheduler icm_renderscheduler_reference(icm_renderscheduler wrap);
    int icm_renderscheduler_dereference(icm_renderscheduler wrap);

    void icm_renderscheduler_request_tile(icm_renderscheduler wrap, icm_drawing d, int x, int y, int size, int time);
    void icm_renderscheduler_revoke_request(icm_renderscheduler wrap, icm_drawing d, int x_min, int y_min, int x_max, int y_max);
    void icm_renderscheduler_background_tick(icm_renderscheduler wrap);
    int icm_renderscheduler_collect_request(icm_renderscheduler wrap, icm_drawing d, cairo_rectangle_t *out_tile_rect);

#ifdef __cplusplus
}
#endif

#endif
