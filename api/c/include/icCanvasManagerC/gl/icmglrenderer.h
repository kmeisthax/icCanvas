#ifndef __ICCANVASMANAGER_CAPI__ICM_GL_RENDERER__H__
#define __ICCANVASMANAGER_CAPI__ICM_GL_RENDERER__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_gl_renderer;

    icm_gl_renderer icm_gl_renderer_construct(icm_gl_contextmanager cm, intptr_t ctxt, intptr_t drawable);
    icm_gl_renderer icm_gl_renderer_reference(icm_gl_renderer wrap);
    int icm_gl_renderer_dereference(icm_gl_renderer wrap);

    icm_gl_renderer icm_gl_renderer_downcast(icm_renderer up_obj);
    icm_renderer icm_gl_renderer_upcast(icm_gl_renderer down_obj);

#ifdef __cplusplus
}
#endif

#endif
