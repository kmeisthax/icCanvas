#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

icm_gl_renderer icm_gl_renderer_construct(icm_gl_contextmanager cm, intptr_t ctxt, intptr_t drawable) {
    icCanvasManager::RefPtr<icCanvasManager::GL::ContextManager> cm_inner = (icCanvasManager::GL::ContextManager*)cm;
    auto* w = new icCanvasManager::GL::Renderer(cm_inner, (icCanvasManager::GL::ContextManager::CONTEXT)ctxt, (icCanvasManager::GL::ContextManager::DRAWABLE)drawable);

    w->ref();
    return (void*)w;
};

icm_gl_renderer icm_gl_renderer_reference(icm_gl_renderer wrap) {
    auto* w = (icCanvasManager::GL::Renderer*)wrap;
    w->ref();
    return wrap;
};

int icm_gl_renderer_dereference(icm_gl_renderer wrap) {
    auto* w = (icCanvasManager::GL::Renderer*)wrap;
    int refcount = w->deref();

    if (refcount <= 0) {
        delete w;
    }

    return refcount;
};

icm_gl_renderer icm_gl_renderer_downcast(icm_renderer up_obj) {
    auto* up = (icCanvasManager::Renderer*)up_obj;
    auto* down = dynamic_cast<icCanvasManager::GL::Renderer*>(up);
    return (void*)down;
};

icm_renderer icm_gl_renderer_upcast(icm_gl_renderer down_obj) {
    auto* down = (icCanvasManager::GL::Renderer*)down_obj;
    auto* up = static_cast<icCanvasManager::Renderer*>(down);

    return (void*)up;
};
