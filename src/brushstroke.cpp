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

icCanvasManager::BrushStroke::BrushStroke() : pos(0), _base_thickness(65536), _tint_color_red(0), _tint_color_blue(0), _tint_color_green(0), _tint_alpha(65536) {};
icCanvasManager::BrushStroke::~BrushStroke() {};

void icCanvasManager::BrushStroke::pen_begin(int32_t x, int32_t y) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);

    thePt._x = cp_x;
    thePt._y = cp_y;
    thePt._attr.x = cp_x;
    thePt._attr.y = cp_y;

    this->_curve.set_point(this->pos, 0, thePt);
};

void icCanvasManager::BrushStroke::pen_begin_pressure(int32_t pressure) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);

    thePt._attr.pressure = pressure;

    this->_curve.set_point(this->pos, 0, thePt);
};

void icCanvasManager::BrushStroke::pen_begin_tilt(int32_t tilt, int32_t angle) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);

    thePt._attr.tilt = tilt;
    thePt._attr.angle = angle;

    this->_curve.set_point(this->pos, 0, thePt);
};

void icCanvasManager::BrushStroke::pen_begin_velocity(int32_t delta_x, int32_t delta_y) {
    if (this->_curve.count_points() == 0) this->_curve.extend_spline();
    auto& thePt = this->_curve.get_point(this->pos, 0);

    thePt._attr.dx = delta_x;
    thePt._attr.dy = delta_y;

    this->_curve.set_point(this->pos, 0, thePt);
};

void icCanvasManager::BrushStroke::pen_to(int32_t cp_x, int32_t cp_y, int32_t to_x, int32_t to_y); {
    auto &cppt = this->_curve.get_point(this->pos, 1);
    auto &topt = this->_curve.get_point(this->pos, 2);

    cppt._x = cp_x;
    cppt._y = cp_y;
    cppt._attr.x = cp_x;
    cppt._attr.y = cp_y;

    topt._x = cp_x;
    topt._y = cp_y;
    topt._attr.x = cp_x;
    topt._attr.y = cp_y;

    this->_curve.set_point(this->pos, 1, cppt);
    this->_curve.set_point(this->pos, 2, topt);
};

void icCanvasManager::BrushStroke::pen_to_pressure(int32_t cp_pressure, int32_t to_pressure) {
    auto &cppt = this->_curve.get_point(this->pos, 1);
    auto &topt = this->_curve.get_point(this->pos, 2);

    cppt._attr.pressure = cp_pressure;
    topt._attr.pressure = to_pressure;

    this->_curve.set_point(this->pos, 1, cppt);
    this->_curve.set_point(this->pos, 2, topt);
};

void icCanvasManager::BrushStroke::pen_to_tilt(int32_t cp_tilt, int32_t cp_angle, int32_t to_tilt, int32_t to_angle) {
    auto &cppt = this->_curve.get_point(this->pos, 1);
    auto &topt = this->_curve.get_point(this->pos, 2);

    cppt._attr.tilt = cp_tilt;
    cppt._attr.angle = cp_angle;
    topt._attr.tilt = to_tilt;
    topt._attr.angle = to_angle;

    this->_curve.set_point(this->pos, 1, cppt);
    this->_curve.set_point(this->pos, 2, topt);
};

void icCanvasManager::BrushStroke::pen_to_velocity(int32_t cp_delta_x, int32_t cp_delta_y, int32_t to_delta_x, int32_t to_delta_y) {
    auto &cppt = this->_curve.get_point(this->pos, 1);
    auto &topt = this->_curve.get_point(this->pos, 2);

    cppt._attr.delta_x = cp_delta_x;
    cppt._attr.delta_y = cp_delta_y;
    topt._attr.delta_x = to_delta_x;
    topt._attr.delta_y = to_delta_y;

    this->_curve.set_point(this->pos, 1, cppt);
    this->_curve.set_point(this->pos, 2, topt);
};

void icCanvasManager::BrushStroke::pen_extend(int continuity_level) {
    this->_curve.extend_spline();
    
    auto &lastTopt = this->_curve.get_point(this->pos, 2);
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

/* Set the thickness of the curve brush. */
void icCanvasManager::BrushStroke::set_brush_thickness(int samples) {
    this->_base_thickness = samples;
};
int icCanvasManager::BrushStroke::brush_thickness() {
    return this->_base_thickness;
};

void icCanvasManager::BrushStroke::set_brush_tint(int r, int g, int b) {
    this->_tint_color_red = r;
    this->_tint_color_green = g;
    this->_tint_color_blue = b;
};

void icCanvasManager::BrushStroke::brush_tint(int *r, int *g, int *b) {
    if (r) *r = this->_tint_color_red;
    if (g) *g = this->_tint_color_green;
    if (b) *b = this->_tint_color_blue;
};

void icCanvasManager::BrushStroke::set_brush_opacity(int alpha) {
    this->_tint_alpha = alpha;
};

int icCanvasManager::BrushStroke::brush_opacity() {
    return this->_tint_alpha;
};

icCanvasManager::BrushStroke::spline_size_type icCanvasManager::BrushStroke::count_segments() {
    return this->_curve.count_points();
};

cairo_rectangle_t icCanvasManager::BrushStroke::bounding_box() {
    //TODO: calculate bounding box
};
