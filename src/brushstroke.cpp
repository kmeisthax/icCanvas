#include <icCanvasManager.hpp>

icCanvasManager::BrushStroke::__ControlPoint icCanvasManager::BrushStroke::__ControlPoint::operator+ (const icCanvasManager::BrushStroke::__ControlPoint& that) {
    icCanvasManager::BrushStroke::__ControlPoint us;
    
    us.x = this->x + that.x;
    us.y = this->y + that.y;
    us.pressure = this->pressure + that.pressure;
    us.tilt = this->tilt + that.tilt;
    us.angle = this->angle + that.angle;
    us.dx = this->dx + that.dx;
    us.dy = this->dy + that.dy;
    
    return us;
};

icCanvasManager::BrushStroke::__ControlPoint icCanvasManager::BrushStroke::__ControlPoint::operator- (const icCanvasManager::BrushStroke::__ControlPoint& that) {
    icCanvasManager::BrushStroke::__ControlPoint us;
    
    us.x = this->x - that.x;
    us.y = this->y - that.y;
    us.pressure = this->pressure - that.pressure;
    us.tilt = this->tilt - that.tilt;
    us.angle = this->angle - that.angle;
    us.dx = this->dx - that.dx;
    us.dy = this->dy - that.dy;
    
    return us;
};

icCanvasManager::BrushStroke::__ControlPoint icCanvasManager::BrushStroke::__ControlPoint::operator* (const float& that) {
    icCanvasManager::BrushStroke::__ControlPoint us;
    
    us.x = this->x * that;
    us.y = this->y * that;
    us.pressure = this->pressure * that;
    us.tilt = this->tilt * that;
    us.angle = this->angle * that;
    us.dx = this->dx * that;
    us.dy = this->dy * that;
    
    return us;
};
