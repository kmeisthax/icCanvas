#ifndef __ICCANVASMANAGER_CAPI__ICM_DISPLAYSUITE__H__
#define __ICCANVASMANAGER_CAPI__ICM_DISPLAYSUITE__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_displaysuite;

    icm_displaysuite icm_displaysuite_reference(icm_displaysuite wrap);
    int icm_displaysuite_dereference(icm_displaysuite wrap);

#ifdef __cplusplus
}
#endif

#endif
