#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_cairo_displaysuite icm_cairo_displaysuite_construct() {
        icCanvasManager::Cairo::DisplaySuite* d = new icCanvasManager::Cairo::DisplaySuite();
        d->ref();

        return (icm_cairo_displaysuite*)d;
    };

    icm_cairo_displaysuite icm_cairo_displaysuite_reference(icm_cairo_displaysuite wrap) {
        auto d = (icCanvasManager::Cairo::DisplaySuite*)w;
        d->ref();

        return w;
    };

    int icm_cairo_displaysuite_dereference(icm_cairo_displaysuite wrap) {
        auto* d = (icCanvasManager::Cairo::DisplaySuite*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_cairo_displaysuite icm_cairo_displaysuite_downcast(icm_displaysuite up_obj) {
        auto* up = (icCanvasManager::DisplaySuite*)up_obj;
        auto* down = dynamic_cast<icCanvasManager::Cairo::DisplaySuite*>(up);
        return (void*)down;
    };

    icm_displaysuite icm_cairo_displaysuite_upcast(icm_cairo_displaysuite down_obj) {
        auto* down = (icCanvasManager::Cairo::DisplaySuite*)down_obj;
        auto* up = static_cast<icCanvasManager::DisplaySuite*>(down);

        return (void*)up;
    };
}
