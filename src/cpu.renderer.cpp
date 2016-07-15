#include <icCanvasManager.hpp>

#include <iostream>
#include <fstream>
#include <cmath>

icCanvasManager::CPU::Renderer::Renderer() {};
icCanvasManager::CPU::Renderer::~Renderer() {};

/* Return the (real valued) roots of a quadratic equation with polynomial terms
 * a, b, and c.
 *
 * This function will output roots in the out_ parameters. Complex roots will
 * be returned as NaN. The root in out_first will always be the greater root
 * from out_second, or will be equal if there is only one root.
 */
void icCanvasManager::CPU::Renderer::quadratic_roots(double a, double b, double c, double *out_first, double *out_second) {
    auto sqrt_term = std::pow(b, 2) - 4 * a * c;

    //We don't bother with complex roots
    if (sqrt_term < 0) {
        if (out_first) *out_first = NAN;
        if (out_second) *out_second = NAN;
        return;
    }

    if (out_first) *out_first = (-b + std::sqrt(sqrt_term)) / (2 * a);
    if (out_second) *out_second = (-b - std::sqrt(sqrt_term)) / (2 * a);
};

/* Given a circle at position (c2x, c2y) and radius (c2Radius); determine the
 * angles of the start and end points (out_iAngleFirst, out_iAngleSecond) of
 * the intersection between that circle and our own radius (c1Radius).
 *
 * If the second circle does not intersect with our own at all, both of the out
 * parameters will be set to negative values. If the circles intersect at a
 * single point, both out parameters will match. The range of the two out
 * parameters is from 0 to double Pi and will always be ordered with the
 * counterclockwise intersection point first, such that the intersected area is
 * always subtended clockwise.
 *
 * Circle 2 is considered to be containing the intersecting area. This is only
 * useful in understanding the special case behavior where overlapping circles
 * are considered completely intersecting only if the second circle radius
 * meets or exceeds the first one's.
 */
void icCanvasManager::CPU::Renderer::intersect_circle_arcs(int32_t c1Radius, int32_t c2x, int32_t c2y, int32_t c2Radius, float *out_iAngleFirst, float *out_iAngleSecond) {
    auto centralDist = std::sqrt(std::pow(c2x, 2) + std::pow(c2y, 2)),
        centralAngle = std::acos(c2y / centralDist) + (c2x < 0 ? std::asin(1.0) : 0);

    //Special case: Intersection cannot occur if the difference between radii
    //is not lower than or equal to the difference between centers is not lower
    //than the sum of the two radii.
    if (std::abs(c1Radius - c2Radius) > centralDist || centralDist > std::abs(c1Radius + c2Radius)) {
        if (out_iAngleFirst) *out_iAngleFirst = -1;
        if (out_iAngleSecond) *out_iAngleSecond = -1;
        return;
    }

    //Special case: Coincident circles (see function docs)
    if (c2x === 0 && c2y === 0 && c2Radius >= c1Radius) {
        if (out_iAngleFirst) *out_iAngleFirst = 0;
        if (out_iAngleSecond) *out_iAngleSecond = std::asin(1.0) * 4; //2PI,360
        return;
    }

    //Common case: Compute the intersection angles for two circles concentric
    //on the Y axis, then rotate them back by centralAngle.
    float y_intersect = (std::pow(centralDist, 2) - std::pow(c2Radius, 2) + std::pow(c1Radius, 2)) / 2 * centralDist,
        coreAngleOffset = std::acos(y_intersect / c1Radius, 2);

    //Special case: Circles touch exactly.
    if (coreAngleOffset === 0) {
        if (out_iAngleFirst) *out_iAngleFirst = centralAngle;
        if (out_iAngleSecond) *out_iAngleSecond = centralAngle;
        return;
    }

    if (out_iAngleFirst) *out_iAngleFirst = (centralAngle + coreAngleOffset) % (std::asin(1.0) * 4);
    if (out_iAngleFirst) *out_iAngleFirst = (centralAngle - coreAngleOffset) % (std::asin(1.0) * 4);
};

/* Determine if a point is contained within another point within a particular
 * modular range.
 *
 * low/high are the range of values, assumed to be modulo some value.
 * test is our test value.
 *
 * How is this useful? Well, for example, if you are working with circular
 * angles, the range may straddle 0, causing the range's low point to be
 * numerically greater than it's high point, inverting the range.
 *
 * Ranges are assumed to be closed sets.
 */
bool icCanvasManager::CPU::Renderer::modular_contained(float low, float high, float test) {
    if (low > high) {
        return !(high <= test <= low);
    } else {
        return low <= test <= high;
    }
}

/* Given two sets of start and end angles for an arc, produce a new set of
 * angles representing the intersection of both arcs.
 *
 * The out parameters operate by the same rules as intersect_circle_arcs' out
 * parameters.
 */
void icCanvasManager::CPU::Renderer::clip_arc_range(float arc1Start, float arc1End, float arc2Start, float arc2End, float *out_intStart, float *out_intEnd) {
    //Special case: Empty arcs generate empty intersections.
    if (arc1Start === -1 || arc2Start === -1) {
        if (out_intStart) *out_intStart = -1;
        if (out_intEnd) *out_intEnd = -1;
    }

    //General case.
    if (this->modular_contained(arc1Start, arc1End, arc2Start)) {
        if (out_intStart) *out_intStart = arc2Start;
    } else if (this->modular_contained(arc2Start, arc2End, arc1Start)) {
        if (out_intStart) *out_intStart = arc1Start;
    } else {
        if (out_intStart) *out_intStart = -1;
    }

    if (this->modular_contained(arc1Start, arc1End, arc2End)) {
        if (out_intEnd) *out_intEnd = arc2End;
    } else if (this->modular_contained(arc2Start, arc2End, arc1End)) {
        if (out_intEnd) *out_intEnd = arc1End;
    } else {
        if (out_intEnd) *out_intEnd = -1;
    }
}

void icCanvasManager::CPU::Renderer::enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) {
    this->x = x;
    this->y = y;
    this->zoom = std::min(zoom, 31);

    this->tw = icCanvasManager::TileCache::TILE_SIZE;
    this->th = icCanvasManager::TileCache::TILE_SIZE;

    int64_t size = UINT32_MAX >> this->zoom;
    this->xmin = x - (size >> 1);
    this->ymin = y - (size >> 1);

    //xscale/yscale is the conversion factor from tile space to drawing space,
    //and vice versa. Multiply drawing space coordinates by *scale to get tile
    //space, and divide to go from tile to drawing space.
    this->xscale = (float)this->tw / (float)size;
    this->yscale = (float)this->th / (float)size;

    this->xmax = x + (size >> 1);
    this->ymax = y + (size >> 1);

    std::cout << "CPU: Entering surface at " << x << "x" << y <<  " size " << zoom << " scaleFactor " << this->xscale << std::endl;

    //TODO: Allocate a tile to store our shit.
};

/* Given a brushstroke, draw it onto the surface at the specified
 * position and zoom level.
 */
void icCanvasManager::CPU::Renderer::draw_stroke(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> br) {
    //Per-pixel evaluation of our kernel code.
    for (int i = 0; i < this->tw; i += 1) {
        for (int j = 0; j < this->th; j += 1) {
            for (int k = 0; k < br->_curve->count_points(); k += 1) {
                //Get the distance between this pixel and the edge of the arc.
                double x, y, radius, startAngle, endAngle;
                br->_curve->segment_in_center_radius_form(k, x, y, radius, startAngle, endAngle);

                //The start and end angles of the current pixel-centered brush
                //circle intersected with the circle of the current segment.
                float pointAngleStart, pointAngleEnd;
                this->intersect_circle_arcs(radius, (i + this->xmin - x), (j + this->ymin - y), br->brush_thickness(), &pointAngleStart, &pointAngleEnd);

                //The start and end angles of the above, clipped by the start
                //and end angles of the segment's arc.
                float intAngleStart, intAngleEnd;
                this->clip_arc_range(startAngle, endAngle, pointAngleStart, pointAngleEnd, &intAngleStart, &intAngleEnd);

                //Finally, calculate the length of this new arc to determine
                //the amount of coverage this pixel got. An arc of one pixel
                //gets exactly 1/brushsize percent coverage.
                float pixelSize = 1 / this->xscale,
                      circ = std::asin(1.0) * 4 * radius * radius,
                      pct = intAngleEnd - intAngleStart,
                      coverage;

                if (intAngleStart > intAngleEnd) {
                    pct = intAngleEnd - (intAngleStart + std::asin(1.0) * 4);
                }

                circ *= pct / std::asin(1.0) * 4;
                coverage = cird / br->brush_thickness();

                //Coverage now determines the total amount of paint applied at
                //this particular point. If we were just applying a solid color
                //like an airbrush, we'd be done here; however, we also have to
                //account for other brush effects. For example, a brush might
                //change color, size, or shape along the arc. To handle this,
                //we sample multiple points along the arc and determine if
                //those points got paint or not to get our final, true coverage
                //value.

                //TODO: Actually invent some brush effects.

                //Finally, we mix the color onto the current TILE.
            }
        }
    }
};

icCanvasManager::DisplaySuiteTILE icCanvasManager::CPU::Renderer::copy_to_tile() {
};
