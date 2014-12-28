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
    return this->_curve.count_points();
};

class icCanvasManager::BrushStroke::__DerivFunctor {
    icCanvasManager::BrushStroke::__Spline::derivative_type& d;
    int segment;
    public:
        __DerivFunctor(icCanvasManager::BrushStroke::__Spline::derivative_type& d, int segment) : d(d), segment(segment) {};
        icCanvasManager::BrushStroke::__ControlPoint operator() (float t) {
            return this->d.evaluate_for_point(t + segment, segment);
        }
};
class icCanvasManager::BrushStroke::__SecondDerivFunctor {
    icCanvasManager::BrushStroke::__Spline::derivative_type::derivative_type& d;
    int segment;
    public:
        __SecondDerivFunctor(icCanvasManager::BrushStroke::__Spline::derivative_type::derivative_type& d, int segment) : d(d), segment(segment) {};
        icCanvasManager::BrushStroke::__ControlPoint operator() (float t) {
            return this->d.evaluate_for_point(t + segment, segment);
        }
};

/* Run root-finding for the X and Y parameters of a control point on the range [0, 1) */
template <typename Functor, typename DerivFunctor>
static void newtonian_roots(Functor f, DerivFunctor fprime, std::vector<float>& x_roots, std::vector<float>& y_roots) {
    for (float i = 0.0f; i < 1.0f; i += 0.1f) {
        float t = i;
        auto divergence = fabs(f(t).x);

        while (divergence > 0.0001f) {
            t = t - ((double)f(t).x / (double)fprime(t).x);
            divergence = fabs(f(t).x);
            if (t < 0.0f || t > 1.0f) break;
        }

        if (t < 0.0f || t > 1.0f) {
        } else if (x_roots.size() == 0 || fabs(x_roots.back() - t) > 0.001f) x_roots.push_back(t);

        t = i;
        divergence = fabs(f(t).y);
        while (divergence > 0.0001f) {
            t = t - ((double)f(t).y / (double)fprime(t).y);
            divergence = fabs(f(t).y);
            if (t < 0.0f || t > 1.0f) break;
        }

        if (t < 0.0f || t > 1.0f) {
        } else if (y_roots.size() == 0 || fabs(y_roots.back() - t) > 0.001f) y_roots.push_back(t);
    }
}

cairo_rectangle_t icCanvasManager::BrushStroke::bounding_box() {
    cairo_rectangle_t out_bbox;
    auto first_derivative = this->_curve.derivative();
    auto second_derivative = first_derivative.derivative();

    int xmin = INT32_MAX, xmax = INT32_MIN, ymin = INT32_MAX, ymax = INT32_MIN;

    for (int i = 0; i < this->_curve.count_points(); i++) {
        icCanvasManager::BrushStroke::__DerivFunctor fprime(first_derivative, i);
        icCanvasManager::BrushStroke::__SecondDerivFunctor f2prime(second_derivative, i);
        std::vector<float> fprime_x_roots, fprime_y_roots;

        fprime_x_roots.push_back(0.0f);
        fprime_y_roots.push_back(0.0f);

        ::newtonian_roots(fprime, f2prime, fprime_x_roots, fprime_y_roots);

        fprime_x_roots.push_back(1.0f);
        fprime_y_roots.push_back(1.0f);

        for (float t : fprime_x_roots) {
            if (t < 0.0f || t > 1.0f) continue;

            auto pt = this->_curve.evaluate_for_point(i + t, i);
            if (pt.x < xmin) xmin = pt.x;
            if (pt.x > xmax) xmax = pt.x;
            if (pt.y < ymin) ymin = pt.y;
            if (pt.y > ymax) ymax = pt.y;
        }

        for (float t : fprime_y_roots) {
            if (t < 0.0f || t > 1.0f) continue;

            auto pt = this->_curve.evaluate_for_point(i + t, i);
            if (pt.x < xmin) xmin = pt.x;
            if (pt.x > xmax) xmax = pt.x;
            if (pt.y < ymin) ymin = pt.y;
            if (pt.y > ymax) ymax = pt.y;
        }
    }

    out_bbox.x = xmin;
    out_bbox.y = ymin;
    out_bbox.width = xmax - xmin;
    out_bbox.height = ymax - ymin;

    return out_bbox;
};
