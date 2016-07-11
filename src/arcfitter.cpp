#include <icCanvasManager.hpp>

#include <cmath>
#include <iostream>
#include <algorithm>
#include <limits>

icCanvasManager::ArcFitter::ArcFitter() {};
icCanvasManager::ArcFitter::~ArcFitter() {};

void icCanvasManager::ArcFitter::begin_fitting(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> storage, int error_threshold) {
    if (this->unfitted_points.size() > 0) this->unfitted_points.clear();
    this->target_curve = storage;
    this->unfitted_id = 0;
    this->error_threshold = error_threshold;
};

void icCanvasManager::ArcFitter::fit_curve(int max_pts, int center_pt) {
    auto ptsize = std::min((decltype(this->unfitted_points.size()))max_pts, this->unfitted_points.size());

    if (ptsize <= 0) return;
    if (center_pt <= 0) return;
    if (center_pt > ptsize) return;

    auto& pt_a = this->unfitted_points.at(0);
    auto& pt_b = this->unfitted_points.at(center_pt);
    auto& pt_c = this->unfitted_points.at(max_pts);

    this->target_curve->pen_begin(pt_a.x, pt_a.y);
    this->target_curve->pen_begin_pressure(pt_a.pressure);
    this->target_curve->pen_begin_tilt(pt_a.tilt, pt_a.angle);
    this->target_curve->pen_begin_velocity(pt_a.dx, pt_a.dy);

    this->target_curve->pen_to(pt_b.x, pt_b.y, pt_c.x, pt_c.y);
    this->target_curve->pen_to_pressure(pt_b.pressure, pt_c.pressure);
    this->target_curve->pen_to_tilt(pt_b.tilt, pt_b.angle, pt_c.tilt, pt_c.angle);
    this->target_curve->pen_to_velocity(pt_b.dx, pt_b.dy, pt_c.dx, pt_c.dy);

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
    this->unfitted_points.push_back(cp);

    auto ptsize = this->unfitted_points.size();
    if (ptsize >= 3) { //We need a minimum point count to start splitting polyarcs
        int best_center_point = -1;
        float lowest_radial_error = std::numeric_limits<float>::infinity();

        //Iterate through all possible points and see which one has the lowest radial error.
        //TODO: Replace with some sort of heurustic or hill climbing.
        for (int i = 1; i < (ptsize - 1); i += 1) {
            this->fit_curve(ptsize, i);
            auto errorData = this->measure_fitting_error();

            if (errorData.radialError < lowest_radial_error) {
                best_center_point = i;
                lowest_radial_error = errorData.radialError;
            }
        }

        //Finally, refit the curve using the selected point.
        this->fit_curve(ptsize, best_center_point);

        //If we've exceeded our error threshold, segment the spline.
        //We make sure to start the next list of points with the same CP we
        //just terminated the last spline segment with.
        if (lowest_radial_error > this->error_threshold) {
            this->unfitted_points.clear();
            this->unfitted_points.push_back(cp);

            this->target_curve->pen_extend();
        }
    }
};

void icCanvasManager::ArcFitter::finish_fitting() {
    auto ptsize = this->unfitted_points.size();
    std::cout << "Ptsize: " << ptsize << std::endl;

    //TODO: If we end the segment with 2 points remaining, bodge a final
    //segment onto the line.
}

void icCanvasManager::ArcFitter::prepare_for_reuse() {
    if (this->unfitted_points.size() > 0) this->unfitted_points.clear();
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
