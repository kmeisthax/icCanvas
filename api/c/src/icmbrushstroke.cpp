#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_brushstroke icm_brushstroke_construct() {
        icCanvasManager::BrushStroke* d = new icCanvasManager::BrushStroke();
        d->ref();

        return (icm_brushstroke)d;
    };

    icm_brushstroke icm_brushstroke_reference(icm_brushstroke w) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->ref();

        return w;
    };
    int icm_brushstroke_dereference(icm_brushstroke w) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    void icm_brushstroke_pen_begin(icm_brushstroke w, int32_t x, int32_t y) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_begin(x, y);
    };

    void icm_brushstroke_pen_begin_pressure(icm_brushstroke w,
        int32_t pressure) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_begin_pressure(pressure);
    };
    void icm_brushstroke_pen_begin_tilt(icm_brushstroke w, int32_t tilt,
        int32_t angle) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_begin_tilt(tilt, angle);
    };
    void icm_brushstroke_pen_begin_velocity(icm_brushstroke w, int32_t delta_x,
        int32_t delta_y) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_begin_velocity(delta_x, delta_y);
    };

    void icm_brushstroke_pen_to(icm_brushstroke w, int32_t fromcp_x,
        int32_t fromcp_y, int32_t tocp_x, int32_t tocp_y, int32_t to_x,
        int32_t to_y) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_to(fromcp_x, fromcp_y, tocp_x, tocp_y, to_x, to_y);
    };
    void icm_brushstroke_pen_to_pressure(icm_brushstroke w,
        int32_t fromcp_pressure, int32_t tocp_pressure, int32_t to_pressure) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_to_pressure(fromcp_pressure, tocp_pressure, to_pressure);
    };
    void icm_brushstroke_pen_to_tilt(icm_brushstroke w, int32_t fromcp_tilt,
        int32_t fromcp_angle, int32_t tocp_tilt, int32_t tocp_angle,
        int32_t to_tilt, int32_t to_angle) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_to_tilt(fromcp_tilt, fromcp_angle, tocp_tilt, tocp_angle, to_tilt, to_angle);
    };
    void icm_brushstroke_pen_to_velocity(icm_brushstroke w,
        int32_t fromcp_delta_x, int32_t fromcp_delta_y, int32_t tocp_delta_x,
        int32_t tocp_delta_y, int32_t to_delta_x, int32_t to_delta_y) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_to_velocity(fromcp_delta_x, fromcp_delta_y, tocp_delta_x, tocp_delta_y, to_delta_x, to_delta_y);
    };

    void icm_brushstroke_pen_extend(icm_brushstroke w, int continuity_level) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_extend(continuity_level);
    };
    void icm_brushstroke_pen_back(icm_brushstroke w) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        d->pen_back();
    };

    size_t icm_brushstroke_count_segments(icm_brushstroke w) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        return d->count_segments();
    };

    cairo_rectangle_t icm_brushstroke_bounding_box(icm_brushstroke w) {
        icCanvasManager::BrushStroke* d = (icCanvasManager::BrushStroke*)w;
        return d->bounding_box();
    };
}
