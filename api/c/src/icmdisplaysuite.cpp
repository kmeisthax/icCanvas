#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_displaysuite icm_displaysuite_reference(icm_displaysuite wrap) {
        auto d = (icCanvasManager::DisplaySuite*)w;
        d->ref();

        return w;
    };

    int icm_displaysuite_dereference(icm_displaysuite wrap) {
        auto* d = (icCanvasManager::DisplaySuite*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };
}
