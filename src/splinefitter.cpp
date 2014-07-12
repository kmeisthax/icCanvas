#include <icCanvasManager.h>

icCanvasManager::SplineFitter::SplineFitter() {};
icCanvasManager::SplineFitter::~SplineFitter() {};

icCanvasManager::SplineFitter::begin_fitting(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> storage, int error_threshold) {
    this->unfitted_points.clear();
    this->target_curve = storage;
};

icCanvasManager::SplineFitter::add_fit_point(int x, int y, int pressure, int tilt, int angle, int dx, int dy) {
    icCanvasManager::BrushStroke::__ControlPoint cp;
    
    cp.x = x;
    cp.y = y;
    cp.pressure = pressure;
    cp.tilt = tilt;
    cp.angle = angle;
    cp.dx = dx;
    cp.dy = dy;
    
    this->unfitted_points.push_back(cp);
};

icCanvasManager::SplineFitter::finish_fitting() {};
