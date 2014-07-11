#ifndef __ICCANVASMANAGER_SPLINEFITTER_HPP_
#define __ICCANVASMANAGER_SPLINEFITTER_HPP_

#import <vector>

namespace icCanvasManager {
    class SplineFitter : public RefCnt {
        std::vector<BrushStoke::__ControlPoint> unfitted_points;
        RefPtr<BrushStroke> target_curve;
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
         * During the fitting operation, the BrushStroke given may be filled
         * with a best-guess estimation of the final curve as you fill points
         * into it. You must finish the operation with finish_fitting before
         * using the final curve for anything other than an interactive
         * preview.
         */
        void add_fit_point(int x, int y, int pressure, int tilt, int angle, int dx, int dy);

        /* Generate the final curve.
         */
        void finish_fitting();
    }
}

#endif
