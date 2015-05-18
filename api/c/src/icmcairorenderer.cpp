#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_cairo_renderer icm_cairo_renderer_construct() {
        icCanvasManager::Cairo::Renderer* d = new icCanvasManager::Cairo::Renderer();
        d->ref();

        return (icm_cairo_renderer*)d;
    };

    icm_cairo_renderer icm_cairo_renderer_reference(icm_cairo_renderer wrap) {
        auto d = (icCanvasManager::Cairo::Renderer*)w;
        d->ref();

        return w;
    };

    int icm_cairo_renderer_dereference(icm_cairo_renderer wrap) {
        auto* d = (icCanvasManager::Cairo::Renderer*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_cairo_renderer icm_cairo_renderer_downcast(icm_renderer up_obj) {
        auto* up = (icCanvasManager::Renderer*)up_obj;
        auto* down = dynamic_cast<icCanvasManager::Cairo::Renderer*>(up);
        return (void*)down;
    };

    icm_renderer icm_cairo_renderer_upcast(icm_cairo_renderer down_obj) {
        auto* down = (icCanvasManager::Cairo::Renderer*)down_obj;
        auto* up = static_cast<icCanvasManager::Renderer*>(down);

        return (void*)up;
    };
}
