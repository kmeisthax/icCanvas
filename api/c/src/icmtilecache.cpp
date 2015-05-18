#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_tilecache icm_tilecache_construct() {
        icCanvasManager::TileCache* d = new icCanvasManager::TileCache();
        d->ref();

        return (icm_tilecache*)d;
    };

    icm_tilecache icm_tilecache_reference(icm_tilecache wrap) {
        auto d = (icCanvasManager::TileCache*)w;
        d->ref();

        return w;
    };

    int icm_tilecache_dereference(icm_tilecache wrap) {
        auto* d = (icCanvasManager::TileCache*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_displaysuite icm_tilecache_display_suite(icm_tilecache w) {
        auto d = (icCanvasManager::TileCache*)w;

        return (icm_displaysuite)d->display_suite;
    };
    void icm_tilecache_set_display_suite(icm_tilecache w, icm_displaysuite ds) {
        auto d = (icCanvasManager::TileCache*)w;
        auto ds2 = (icCanvasManager::DisplaySuite*)ds;

        d->set_display_suite(ds2);
    };
}
