#ifndef __ICCANVASMANAGER_SPLINEFITTER_HPP_
#define __ICCANVASMANAGER_SPLINEFITTER_HPP_

#include "../icCanvasManager.hpp"

#include <vector>
#include <Eigen/Dense>

namespace icCanvasManager {
    class BrushStroke;
    
    class SplineFitter : public RefCnt {
        //Constant data
        Eigen::Matrix4f beizer_4_coeff;
        Eigen::Matrix4f beizer_4_invcoeff;
        
        //Per-fit data
        std::vector<BrushStroke::__ControlPoint> unfitted_points;
        std::vector<int> distances;
        RefPtr<BrushStroke> target_curve;
        int unfitted_id;
        int error_threshold;

        //Measure the fitting error of the current curve segment.
        struct __ErrorPoint {
            float x, y;
            float pressure;
            float tilt, angle;
            float dx, dy;
        };
        __ErrorPoint measure_fitting_error();
    public:
        SplineFitter();
        virtual ~SplineFitter();

        /* Configure the object to begin fitting points to a Beizer spline.
         *
         * The BrushStroke pointed to by storage will have it's curve data
         * replaced with the newly fitted curve.
         *
         * The error threshold is how much error (measured in canvas units) is
         * acceptable. It should be roughly scaled to the current canvas
         * viewport size.
         */
        void begin_fitting(RefPtr<BrushStroke> storage, int error_threshold);

        /* Append a point to the fitting set.
         *
         * This function may only be called after a storage stroke and error
         * threshold have been established with begin_fitting.
         *
         * This function may not be called before calling begin_fitting or
         * after calling prepare_for_reuse.
         */
        void add_fit_point(int x, int y, int pressure, int tilt, int angle, int dx, int dy);

        /* Finalize the fitted stroke.
         *
         * This function may not be called before calling begin_fitting or
         * after calling prepare_for_reuse.
         */
        void finish_fitting();

        /* Reset SplineFitter to initial state.
         */
        void prepare_for_reuse();
    };
}

#endif
