#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_gl_displaysuite icm_gl_displaysuite_construct() {
        icCanvasManager::GL::DisplaySuite* d = new icCanvasManager::GL::DisplaySuite();
        d->ref();

        return (icm_gl_displaysuite*)d;
    };

    icm_gl_displaysuite icm_gl_displaysuite_reference(icm_gl_displaysuite wrap) {
        auto d = (icCanvasManager::GL::DisplaySuite*)w;
        d->ref();

        return w;
    };

    int icm_gl_displaysuite_dereference(icm_gl_displaysuite wrap) {
        auto* d = (icCanvasManager::GL::DisplaySuite*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_gl_displaysuite icm_gl_displaysuite_downcast(icm_displaysuite up_obj) {
        auto* up = (icCanvasManager::DisplaySuite*)up_obj;
        auto* down = dynamic_cast<icCanvasManager::GL::DisplaySuite*>(up);
        return (void*)down;
    };

    icm_displaysuite icm_gl_displaysuite_upcast(icm_gl_displaysuite down_obj) {
        auto* down = (icCanvasManager::GL::DisplaySuite*)down_obj;
        auto* up = static_cast<icCanvasManager::DisplaySuite*>(down);

        return (void*)up;
    };
}
