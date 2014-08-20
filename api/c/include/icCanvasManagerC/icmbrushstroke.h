#ifndef __ICCANVASMANAGER_CAPI__ICM_BRUSHSTROKE__H__
#define __ICCANVASMANAGER_CAPI__ICM_BRUSHSTROKE__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void icm_brushstroke;

    const static int ICM_BRUSHSTROKE_PRESSURE_MAX = 65536;
    const static int ICM_BRUSHSTROKE_TILT_ANGLE_QUARTER = 32400;
    const static int ICM_BRUSHSTROKE_TILT_ANGLE_HALF = 64800;
    const static int ICM_BRUSHSTROKE_TILT_ANGLE_FULL = 129600;

    icm_brushstroke* icm_brushstroke_construct();
    int icm_brushstroke_reference(icm_brushstroke *this);
    int icm_brushstroke_dereference(icm_brushstroke *this);

    void icm_brushstroke_pen_begin(icm_brushstroke* this, int32_t x, int32_t y);

    void icm_brushstroke_pen_begin_pressure(icm_brushstroke* this,
        int32_t pressure);
    void icm_brushstroke_pen_begin_tilt(icm_brushstroke* this, int32_t tilt,
        int32_t angle);
    void icm_brushstroke_pen_begin_velocity(icm_brushstroke* this, int32_t delta_x,
        int32_t delta_y);

    void icm_brushstroke_pen_to(icm_brushstroke* this, int32_t fromcp_x,
        int32_t fromcp_y, int32_t tocp_x, int32_t tocp_y, int32_t to_x,
        int32_t to_y);
    void icm_brushstroke_pen_to_pressure(icm_brushstroke* this,
        int32_t fromcp_pressure, int32_t tocp_pressure, int32_t to_pressure);
    void icm_brushstroke_pen_to_tilt(icm_brushstroke* this, int32_t fromcp_tilt,
        int32_t fromcp_angle, int32_t tocp_tilt, int32_t tocp_angle,
        int32_t to_tilt, int32_t to_angle);
    void icm_brushstroke_pen_to_velocity(icm_brushstroke* this,
        int32_t fromcp_delta_x, int32_t fromcp_delta_y, int32_t tocp_delta_x,
        int32_t tocp_delta_y, int32_t to_delta_x, int32_t to_delta_y);

    void icm_brushstroke_pen_extend(icm_brushstroke* this, int continuity_level);
    void icm_brushstroke_pen_back(icm_brushstroke* this);

    size_t icm_brushstroke_count_segments(icm_brushstroke* this);

#ifdef __cplusplus
}
#endif

#endif
