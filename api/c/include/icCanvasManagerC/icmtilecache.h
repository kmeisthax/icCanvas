#ifndef __ICCANVASMANAGER_CAPI__ICM_TILECACHE__H__
#define __ICCANVASMANAGER_CAPI__ICM_TILECACHE__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_tilecache;

    icm_tilecache icm_tilecache_construct();
    icm_tilecache icm_tilecache_reference(icm_tilecache wrap);
    int icm_tilecache_dereference(icm_tilecache wrap);
    icm_displaysuite icm_tilecache_display_suite(icm_tilecache wrap);
    void icm_tilecache_set_display_suite(icm_tilecache wrap, icm_displaysuite ds);

#ifdef __cplusplus
}
#endif

#endif
