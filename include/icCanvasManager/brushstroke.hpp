#ifndef __ICCANVASMANAGER_BRUSHSTROKE__H_
#define __ICCANVASMANAGER_BRUSHSTROKE__H_

#include "../icCanvasManager.hpp"

#include <vector>
#include <cstdint>

namespace icCanvasManager {
    class Renderer;

    class BrushStroke {
        struct __ControlPoint {
            int x, y;
            int pressure;
            int tilt, angle;
            int dx, dy;
            
            __ControlPoint operator+(const __ControlPoint& that);
            __ControlPoint operator-(const __ControlPoint& that);
            __ControlPoint operator*(const float& that);
        };
        
        typedef TMVBeizer<__ControlPoint, 3> __Spline;
        __ControlPoint _last_cp;
        __Spline _curve;
    public:
        const static int PRESSURE_MAX = 65536;
        const static int TILT_ANGLE_QUARTER = 32400;
        const static int TILT_ANGLE_HALF = 64800;
        const static int TILT_ANGLE_FULL = 129600;

        void pen_begin(int32_t x, int32_t y);
        void pen_begin_pressure(int32_t pressure);
        void pen_begin_tilt(int32_t tilt, int32_t angle);
        void pen_begin_velocity(int32_t delta_x, int32_t delta_y);
        void pen_to(int32_t fromcp_x, int32_t fromcp_y, int32_t tocp_x,
            int32_t tocp_y, int32_t to_x, int32_t to_y);
        void pen_to_pressure(int32_t fromcp_pressure, int32_t tocp_pressure,
            int32_t to_pressure);
        void pen_to_tilt(int32_t fromcp_tilt, int32_t fromcp_angle,
            int32_t tocp_tilt, int32_t tocp_angle, int32_t to_tilt,
            int32_t to_angle);
        void pen_to_velocity(int32_t fromcp_delta_x, int32_t fromcp_delta_y,
            int32_t tocp_delta_x, int32_t tocp_delta_y, int32_t to_delta_x,
            int32_t to_delta_y);
        void pen_back();

        friend class Renderer;
    };
};

#endif
