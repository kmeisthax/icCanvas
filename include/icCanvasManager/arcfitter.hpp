#ifndef __ICCANVASMANAGER_ARCFITTER_HPP_
#define __ICCANVASMANAGER_ARCFITTER_HPP_

#include "../icCanvasManager.hpp"

#include <vector>

namespace icCanvasManager {
    class BrushStroke;

    /* Fit a set of points to an arc spline. The first and last point are used
     * as the A and C points of the arc; B point is selected via binary search
     * from the middle to determine best possible candidate point.
     *
     * TODO: Find a way to accomodate error in non-positional parameters.
     */

    //ARC-Vitter
    class ArcFitter : public RefCnt {
        //Per-fit data
        std::vector<BrushStroke::__ControlPoint> unfitted_points;
        RefPtr<BrushStroke> target_curve;
        int unfitted_id;
        int error_threshold;
        int current_center_point;

        //Measure the fitting error of the current curve segment.
        struct __ErrorPoint {
            float radialError;
            float pressure;
            float tilt, angle;
            float dx, dy;
        };
        __ErrorPoint measure_fitting_error();

        /* Run the (expensive?) curve fitting operation on the current unfit
         * point set.
         *
         * The max_pts parameter determines what point is considered the last
         * point of the curve. The center_pt parameter determines which point
         * is considered the midpoint of the curve used for
         */
        void fit_curve(int max_pts, int center_pt);
    public:
        ArcFitter();
        virtual ~ArcFitter();

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

        /* Reset ArcFitter to initial state.
         */
        void prepare_for_reuse();
    };
}

#endif
