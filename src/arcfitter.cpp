#include <icCanvasManager.hpp>

#include <cmath>
#include <iostream>
#include <algorithm>

icCanvasManager::ArcFitter::ArcFitter() {};
icCanvasManager::ArcFitter::~ArcFitter() {};

void icCanvasManager::ArcFitter::begin_fitting(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> storage, int error_threshold) {
    if (this->unfitted_points.size() > 0) this->unfitted_points.clear();
    this->target_curve = storage;
    this->unfitted_id = 0;
    this->current_center_point = -1;
    this->error_threshold = error_threshold;
};

void icCanvasManager::ArcFitter::fit_curve(int max_pts, int center_pt) {
    auto ptsize = std::min((decltype(this->unfitted_points.size()))max_pts, this->unfitted_points.size());

    if (ptsize <= 0) return;

    //TODO: Elevate three candidate points to comprise the curve.

    this->target_curve->pen_begin(curve_xpos(0,0), curve_ypos(0,0));
    this->target_curve->pen_begin_pressure(curve_pressure(0,0));
    this->target_curve->pen_begin_tilt(curve_tilt(0,0), curve_angle(0,0));
    this->target_curve->pen_begin_velocity(curve_xdelta(0,0), curve_ydelta(0,0));

    this->target_curve->pen_to(curve_xpos(1,0), curve_ypos(1,0), curve_xpos(2,0), curve_ypos(2,0), curve_xpos(3,0), curve_ypos(3,0));
    this->target_curve->pen_to_pressure(curve_pressure(1,0), curve_pressure(2,0), curve_pressure(3,0));
    this->target_curve->pen_to_tilt(curve_tilt(1,0), curve_angle(1,0), curve_tilt(2,0), curve_angle(2,0), curve_tilt(3,0), curve_angle(3,0));
    this->target_curve->pen_to_velocity(curve_xdelta(1,0), curve_ydelta(1,0), curve_xdelta(2,0), curve_ydelta(2,0), curve_xdelta(3,0), curve_ydelta(3,0));

    this->curve_xpos = curve_xpos;
    this->curve_ypos = curve_ypos;
};

void icCanvasManager::ArcFitter::add_fit_point(int x, int y, int pressure, int tilt, int angle, int dx, int dy) {
    std::cout << "Fit pt: " << x << ", " << y << std::endl;
    icCanvasManager::BrushStroke::__ControlPoint cp;

    cp.x = x;
    cp.y = y;
    cp.pressure = pressure;
    cp.tilt = tilt;
    cp.angle = angle;
    cp.dx = dx;
    cp.dy = dy;

    this->target_curve->_fitpts.push_back(cp);

    auto ptsize = this->unfitted_points.size();
    if (ptsize < 1) {
        this->unfitted_points.push_back(cp);
        return;
    }

    if (ptsize > 3) { //We need a minimum point count to start splitting polyarcs
        icCanvasManager::ArcFitter::__ErrorPoint errorPt = this->measure_fitting_error();
        float max_error = std::max(errorPt.radialError, std::max(errorPt.pressure, std::max(errorPt.tilt, std::max(errorPt.angle, std::max(errorPt.dx, errorPt.dy)))));

        if (max_error > (float)this->error_threshold) {
            //Curve exceeds the desired error, time to split
            auto lastcp = this->unfitted_points.back();
            this->unfitted_points.clear();
            this->unfitted_points.push_back(lastcp);
            this->unfitted_points.push_back(cp);

            int xDelta = cp.x - lastcp.x, yDelta = cp.y - lastcp.y;
            int segDist = (int)sqrt((float)xDelta * (float)xDelta + (float)yDelta * (float)yDelta);

            this->distances.clear();
            this->distances.push_back(0);
            this->distances.push_back(segDist);

            this->target_curve->pen_extend();
            this->unfitted_id++;
            std::cout << "Fit curve: " << this->curve_xpos << ", " << this->curve_ypos << std::endl;

            return;
        }
    }

    auto lastcp = this->unfitted_points.back();
    int lastDist = this->distances.back();
    this->unfitted_points.push_back(cp);
    ptsize++;

    int xDelta = cp.x - lastcp.x, yDelta = cp.y - lastcp.y;
    int segDist = (int)sqrt((float)xDelta * (float)xDelta + (float)yDelta * (float)yDelta);
    int newTotalDist = lastDist + segDist;
    this->distances.push_back(newTotalDist);

    this->fit_curve(ptsize);
};

void icCanvasManager::ArcFitter::finish_fitting() {
    auto ptsize = this->unfitted_points.size();
    std::cout << "Ptsize: " << ptsize << std::endl;

    if (ptsize <= 0 && this->target_curve->count_segments() <= 0) {
        //Do nothing.
    } else if (ptsize <= 3 && this->target_curve->count_segments() > 0) {
        this->target_curve->pen_back();
    } else {
        this->fit_curve(ptsize);
        std::cout << "Fit curve: " << this->curve_xpos << ", " << this->curve_ypos << std::endl;
    }
}

void icCanvasManager::ArcFitter::prepare_for_reuse() {
    if (this->unfitted_points.size() > 0) this->unfitted_points.clear();
    if (this->distances.size() > 0) this->distances.clear();
    this->target_curve = NULL;
    this->unfitted_id = 0;
};

icCanvasManager::ArcFitter::__ErrorPoint icCanvasManager::ArcFitter::measure_fitting_error() {
    icCanvasManager::ArcFitter::__ErrorPoint errorPt = {0,0,0,0,0,0};
    int newTotalDist = this->distances.back();
    double xCtr, yCtr, radius, startTh, endTh;

    auto i = this->distances.begin();
    auto j = this->unfitted_points.begin();

    this->target_curve->_curve.segment_in_circle_radius_form(xCtr, yCtr, radius, startTh, endTh);

    for (;
         i != this->distances.end() && j != this->unfitted_points.end();
         i++, j++) {
        float tval = (float)(*i) / (float)newTotalDist;

        icCanvasManager::BrushStroke::__ControlPoint fitted_point = this->target_curve->_curve.evaluate_for_point(this->unfitted_id + tval, this->unfitted_id);

        errorPt.radialError += radius - std::sqrt(std::pow((*j).x - xCtr) + std::pow((*j).y - yCtr));
        errorPt.pressure += std::pow((float)(*j).pressure - (float)fitted_point.pressure, 2.0);
        errorPt.tilt += std::pow((float)(*j).tilt - (float)fitted_point.tilt, 2.0);
        errorPt.angle += std::pow((float)(*j).angle - (float)fitted_point.angle, 2.0);
        errorPt.dx += std::pow((float)(*j).dx - (float)fitted_point.dx, 2.0);
        errorPt.dy += std::pow((float)(*j).dy - (float)fitted_point.dy, 2.0);
    }

    return errorPt;
};
