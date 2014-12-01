#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_drawing icm_drawing_construct() {
        icCanvasManager::Drawing* d = new icCanvasManager::Drawing();
        d->ref();

        return (icm_drawing*)d;
    };

    icm_drawing icm_drawing_reference(icm_drawing w) {
        icCanvasManager::Drawing* d = (icCanvasManager::Drawing*)w;
        d->ref();

        return w;
    };

    int icm_drawing_dereference(icm_drawing w) {
        icCanvasManager::Drawing* d = (icCanvasManager::Drawing*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_brushstroke icm_drawing_stroke_at_time(icm_drawing w, int time) {
        icCanvasManager::Drawing* d = (icCanvasManager::Drawing*)w;
        icCanvasManager::BrushStroke* b = d->stroke_at_time(time);
        b->ref();

        return (icm_brushstroke)b;
    };

    int icm_drawing_strokes_count(icm_drawing w) {
        icCanvasManager::Drawing* d = (icCanvasManager::Drawing*)w;
        return d->strokes_count();
    };

    void icm_drawing_append_stroke(icm_drawing w, icm_brushstroke stroke) {
        icCanvasManager::Drawing* d = (icCanvasManager::Drawing*)w;
        icCanvasManager::BrushStroke* b = (icCanvasManager::BrushStroke*)stroke;
        d->append_stroke(b);
    };
/*
    icm_tilecache icm_drawing_get_tilecache(icm_drawing w) {
        icCanvasManager::Drawing* d = (icCanvasManager::Drawing*)w;
        icCanvasManager::TileCache* t = d->get_tilecache();

        return (icm_tilecache)t;
    }; */
}
