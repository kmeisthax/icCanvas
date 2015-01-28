#ifndef __ICCANVASMANAGER_BRUSHSTROKE__H_
#define __ICCANVASMANAGER_BRUSHSTROKE__H_

#include "../icCanvasManager.hpp"

#include <vector>
#include <cstdint>

#include <cairo.h>

namespace icCanvasManager {
    class Renderer;
    class SplineFitter;

    class BrushStroke : public RefCnt {
        struct __ControlPoint {
            int x, y;
            int pressure;
            int tilt, angle;
            int dx, dy;
            
            __ControlPoint operator+(const __ControlPoint& that);
            __ControlPoint operator-(const __ControlPoint& that);
            __ControlPoint operator*(const float& that);
        };
        
        enum __Attribute {
            ATTRIBUTE_XPOS,
            ATTRIBUTE_YPOS,
            ATTRIBUTE_PRESSURE,
            ATTRIBUTE_TILT,
            ATTRIBUTE_ANGLE,
            ATTRIBUTE_XDELTA,
            ATTRIBUTE_YDELTA
        };
        
        typedef TMVBeizer<__ControlPoint, 3> __Spline;
        __Spline _curve;
        __Spline::size_type pos;

        int _base_thickness;

        class __DerivFunctor;
        class __SecondDerivFunctor;
        class __ThirdDerivFunctor;

        std::vector<__ControlPoint> _fitpts;
    public:
        typedef __Spline::size_type spline_size_type;
        
        BrushStroke();
        virtual ~BrushStroke();
        
        const static int PRESSURE_MAX = 65536;
        const static int TILT_ANGLE_QUARTER = 32400;
        const static int TILT_ANGLE_HALF = 64800;
        const static int TILT_ANGLE_FULL = 129600;

        //Set the start point of the current spline segment.
        void pen_begin(int32_t x, int32_t y);

        //Pressure ranges from 0 to PRESSURE_MAX
        void pen_begin_pressure(int32_t pressure);

        //Tilt ranges from 0 (fully upright) to TILT_ANGLE_QUARTER
        //Angle may exceed TILT_ANGLE_FULL or fall below 0, as needed to
        //    preserve the proper turning direction of the pen. 0 represents
        //    pointing towards the top of the screen. All results should be
        //    interpreted modulo TILT_ANGLE_FULL when rendering.
        void pen_begin_tilt(int32_t tilt, int32_t angle);

        void pen_begin_velocity(int32_t delta_x, int32_t delta_y);
        
        //Set the end and control points of the next spline section.
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
        
        /* Extend the curve with a new spline segment.
         * 
         * The continuity level parameter specifies how much of the new segment
         * should match with the current segment.
         * 
         *   No continuity: (param value negative)
         *      No continuity between spline segments. The contents of the new
         *      spline segments are undefined, you must call both pen_begin and
         *      pen_to functions in order to specify the next segment.
         *   
         *   C0 continuity: (param value 0)
         *      Spline segments share a common join point. The start point of
         *      the new spline is equal to the end point of the previous spline
         *      segment. All other points on the new spline segment are
         *      undefined.
         * 
         * No further notions of continuity are currently supported by this
         * function.
         */
        void pen_extend(int continuity_level = 0);
        
        //Erase the last spline section.
        void pen_back();
        
        /* Set the thickness of the curve brush. */
        void set_brush_thickness(int samples);
        int brush_thickness();

        //Count the number of spline segments.
        spline_size_type count_segments();

        /* Calculate the bounding-box of the curve. */
        cairo_rectangle_t bounding_box();

        friend class Renderer;
        friend class SplineFitter;
    };
};

#endif
