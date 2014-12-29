#ifndef __ICCANVASMANAGER_CAPI__ICM_BRUSHSTROKE__H__
#define __ICCANVASMANAGER_CAPI__ICM_BRUSHSTROKE__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void *icm_brushstroke;

    const static int ICM_BRUSHSTROKE_PRESSURE_MAX = 65536;
    const static int ICM_BRUSHSTROKE_TILT_ANGLE_QUARTER = 32400;
    const static int ICM_BRUSHSTROKE_TILT_ANGLE_HALF = 64800;
    const static int ICM_BRUSHSTROKE_TILT_ANGLE_FULL = 129600;

    icm_brushstroke icm_brushstroke_construct();
    icm_brushstroke icm_brushstroke_reference(icm_brushstroke wrap);
    int icm_brushstroke_dereference(icm_brushstroke wrap);

    void icm_brushstroke_pen_begin(icm_brushstroke wrap, int32_t x, int32_t y);

    void icm_brushstroke_pen_begin_pressure(icm_brushstroke wrap,
        int32_t pressure);
    void icm_brushstroke_pen_begin_tilt(icm_brushstroke wrap, int32_t tilt,
        int32_t angle);
    void icm_brushstroke_pen_begin_velocity(icm_brushstroke wrap, int32_t delta_x,
        int32_t delta_y);

    void icm_brushstroke_pen_to(icm_brushstroke wrap, int32_t fromcp_x,
        int32_t fromcp_y, int32_t tocp_x, int32_t tocp_y, int32_t to_x,
        int32_t to_y);
    void icm_brushstroke_pen_to_pressure(icm_brushstroke wrap,
        int32_t fromcp_pressure, int32_t tocp_pressure, int32_t to_pressure);
    void icm_brushstroke_pen_to_tilt(icm_brushstroke wrap, int32_t fromcp_tilt,
        int32_t fromcp_angle, int32_t tocp_tilt, int32_t tocp_angle,
        int32_t to_tilt, int32_t to_angle);
    void icm_brushstroke_pen_to_velocity(icm_brushstroke wrap,
        int32_t fromcp_delta_x, int32_t fromcp_delta_y, int32_t tocp_delta_x,
        int32_t tocp_delta_y, int32_t to_delta_x, int32_t to_delta_y);

    void icm_brushstroke_pen_extend(icm_brushstroke wrap, int continuity_level);
    void icm_brushstroke_pen_back(icm_brushstroke wrap);

    size_t icm_brushstroke_count_segments(icm_brushstroke wrap);

    cairo_rectangle_t icm_brushstroke_bounding_box(icm_brushstroke wrap);

#ifdef __cplusplus
}
#endif

#endif
