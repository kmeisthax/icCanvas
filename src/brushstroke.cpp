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

icCanvasManager::BrushStroke::BrushStroke() : pos(0) {};
icCanvasManager::BrushStroke::~BrushStroke() {};

void icCanvasManager::BrushStroke::pen_begin(int32_t x, int32_t y) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);
    thePt.x = x;
    thePt.y = y;
};

void icCanvasManager::BrushStroke::pen_begin_pressure(int32_t pressure) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);
    thePt.pressure = pressure;
};

void icCanvasManager::BrushStroke::pen_begin_tilt(int32_t tilt, int32_t angle) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);
    thePt.tilt = tilt;
    thePt.angle = angle;
};

void icCanvasManager::BrushStroke::pen_begin_velocity(int32_t delta_x, int32_t delta_y) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);
    thePt.dx = delta_x;
    thePt.dy = delta_y;
};

void icCanvasManager::BrushStroke::pen_to(int32_t fromcp_x, int32_t fromcp_y, int32_t tocp_x, int32_t tocp_y, int32_t to_x, int32_t to_y) {
    auto &fromcp = this->_curve.get_point(this->pos, 1);
    auto &tocp = this->_curve.get_point(this->pos, 2);
    auto &topt = this->_curve.get_point(this->pos, 3);

    fromcp.x = fromcp_x;
    fromcp.y = fromcp_y;

    tocp.x = tocp_x;
    tocp.y = tocp_y;

    topt.x = to_x;
    topt.y = to_y;
};

void icCanvasManager::BrushStroke::pen_to_pressure(int32_t fromcp_pressure, int32_t tocp_pressure, int32_t to_pressure) {
    auto &fromcp = this->_curve.get_point(this->pos, 1);
    auto &tocp = this->_curve.get_point(this->pos, 2);
    auto &topt = this->_curve.get_point(this->pos, 3);

    fromcp.pressure = fromcp_pressure;
    tocp.pressure = tocp_pressure;
    topt.pressure = to_pressure;
};

void icCanvasManager::BrushStroke::pen_to_tilt(int32_t fromcp_tilt, int32_t fromcp_angle, int32_t tocp_tilt, int32_t tocp_angle, int32_t to_tilt, int32_t to_angle) {
    auto &fromcp = this->_curve.get_point(this->pos, 1);
    auto &tocp = this->_curve.get_point(this->pos, 2);
    auto &topt = this->_curve.get_point(this->pos, 3);

    fromcp.tilt = fromcp_tilt;
    fromcp.angle = fromcp_angle;

    tocp.tilt = tocp_tilt;
    tocp.angle = tocp_angle;

    topt.tilt = to_tilt;
    topt.angle = to_angle;
};

void icCanvasManager::BrushStroke::pen_to_velocity(int32_t fromcp_delta_x, int32_t fromcp_delta_y, int32_t tocp_delta_x, int32_t tocp_delta_y, int32_t to_delta_x, int32_t to_delta_y) {
    auto &fromcp = this->_curve.get_point(this->pos, 1);
    auto &tocp = this->_curve.get_point(this->pos, 2);
    auto &topt = this->_curve.get_point(this->pos, 3);

    fromcp.dx = fromcp_delta_x;
    fromcp.dy = fromcp_delta_y;

    tocp.dx = tocp_delta_x;
    tocp.dy = tocp_delta_y;

    topt.dx = to_delta_x;
    topt.dy = to_delta_y;
};

void icCanvasManager::BrushStroke::pen_extend(int continuity_level) {
    this->_curve.extend_spline();
    
    auto &lastTopt = this->_curve.get_point(this->pos, 3);
    auto &nextFrompt = this->_curve.get_point(this->pos + 1, 0);
    
    if (continuity_level >= 0) {
        nextFrompt = lastTopt;
    }
    
    this->pos++;
};

void icCanvasManager::BrushStroke::pen_back() {
    this->_curve.contract_spline();
    this->pos--;
};

icCanvasManager::BrushStroke::spline_size_type icCanvasManager::BrushStroke::count_segments() {
    this->_curve.count_points();
};