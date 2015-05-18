#ifndef __ICCANVASMANAGER_CAPI__ICM_GL_DISPLAYSUITE__H__
#define __ICCANVASMANAGER_CAPI__ICM_GL_DISPLAYSUITE__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_gl_displaysuite;

    icm_gl_displaysuite icm_gl_displaysuite_construct(icm_gl_contextmanager cm, intptr_t null_drawable);
    icm_gl_displaysuite icm_gl_displaysuite_reference(icm_gl_displaysuite wrap);
    int icm_gl_displaysuite_dereference(icm_gl_displaysuite wrap);

    icm_gl_displaysuite icm_gl_displaysuite_downcast(icm_displaysuite up_obj);
    icm_displaysuite icm_gl_displaysuite_upcast(icm_gl_displaysuite down_obj);

#ifdef __cplusplus
}
#endif

#endif
