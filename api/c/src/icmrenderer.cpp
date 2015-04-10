#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_renderer icm_renderer_reference(icm_renderer w) {
        icCanvasManager::Renderer* d = (icCanvasManager::Renderer*)w;
        d->ref();

        return w;
    };

    int icm_renderer_dereference(icm_renderer w) {
        icCanvasManager::Renderer* d = (icCanvasManager::Renderer*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };
}
