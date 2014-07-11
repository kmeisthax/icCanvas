#include <icCanvasManager.h>

/*
        std::vector<BrushStoke::__ControlPoint> unfitted_points;
        BrushStroke::__Spline fitted_curve;
 */

icCanvasManager::SplineFitter::SplineFitter() {};
icCanvasManager::SplineFitter::~SplineFitter() {};

icCanvasManager::SplineFitter::begin_fitting(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> storage, int error_threshold);
icCanvasManager::SplineFitter::add_fit_point(int x, int y, int pressure, int tilt, int angle, int dx, int dy);
icCanvasManager::SplineFitter::finish_fitting();
