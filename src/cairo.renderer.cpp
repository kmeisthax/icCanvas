#include <icCanvasManager.hpp>
#include <cmath>
#include <iostream>

icCanvasManager::Cairo::Renderer::Renderer():
    xrctxt(NULL), xrsurf(NULL) {
}

icCanvasManager::Cairo::Renderer::~Renderer() {
    if (this->xrsurf) cairo_surface_destroy(this->xrsurf);
    if (this->xrctxt) cairo_destroy(this->xrctxt);
};

void icCanvasManager::Cairo::Renderer::enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) {
    cairo_surface_t* imgsurf = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE);
    this->enter_image_surface(x, y, zoom, imgsurf);
};

void icCanvasManager::Cairo::Renderer::enter_surface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf, const int height, const int width) {
    cairo_surface_reference(xrsurf);

    this->x = x;
    this->y = y;
    this->zoom = std::min(zoom, 31);

    if (this->xrsurf) cairo_surface_destroy(this->xrsurf);
    this->xrsurf = xrsurf;

    if (this->xrctxt) cairo_destroy(this->xrctxt);
    this->xrctxt = cairo_create(this->xrsurf);

    this->tw = width;
    this->th = height;

    int64_t size = UINT32_MAX >> this->zoom;
    this->xmin = x - (size >> 1);
    this->ymin = y - (size >> 1);

    this->xscale = (float)this->tw / (float)size;
    this->yscale = (float)this->th / (float)size;

    this->xmax = x + (size >> 1);
    this->ymax = y + (size >> 1);
}

void icCanvasManager::Cairo::Renderer::enter_image_surface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf) {
    cairo_surface_reference(xrsurf);

    this->x = x;
    this->y = y;
    this->zoom = std::min(zoom, 31);

    if (this->xrsurf) cairo_surface_destroy(this->xrsurf);
    this->xrsurf = xrsurf;

    if (this->xrctxt) cairo_destroy(this->xrctxt);
    this->xrctxt = cairo_create(this->xrsurf);

    this->tw = cairo_image_surface_get_width(this->xrsurf);
    this->th = cairo_image_surface_get_height(this->xrsurf);

    int64_t size = UINT32_MAX >> this->zoom;
    this->xmin = x - (size >> 1);
    this->ymin = y - (size >> 1);

    this->xscale = (float)this->tw / (float)size;
    this->yscale = (float)this->th / (float)size;

    this->xmax = x + (size >> 1);
    this->ymax = y + (size >> 1);

    std::cout << "Rendering a tile at " << x << "x" << y << std::endl;

    cairo_set_source_rgba(this->xrctxt, 1.0, 1.0, 1.0, 0.0);
    cairo_paint(this->xrctxt);
};

void icCanvasManager::Cairo::Renderer::enter_context(const int32_t x, const int32_t y, const int32_t zoom, cairo_t* xrctxt, const int height, const int width) {
    cairo_reference(xrctxt);

    this->x = x;
    this->y = y;
    this->zoom = std::min(zoom, 31);

    if (this->xrsurf) cairo_surface_destroy(this->xrsurf);
    this->xrsurf = NULL;

    if (this->xrctxt) cairo_destroy(this->xrctxt);
    this->xrctxt = xrctxt;

    this->tw = width;
    this->th = height;

    int64_t size = UINT32_MAX >> this->zoom;
    this->xmin = x - (size >> 1);
    this->ymin = y - (size >> 1);

    this->xscale = (float)this->tw / (float)size;
    this->yscale = (float)this->th / (float)size;

    this->xmax = x + (size >> 1);
    this->ymax = y + (size >> 1);
}

cairo_surface_t* icCanvasManager::Cairo::Renderer::retrieve_image_surface() {
    return this->xrsurf;
};

void icCanvasManager::Cairo::Renderer::transfer_to_image_surface(cairo_surface_t* surf) {
    cairo_t* tmpctxt = cairo_create(surf);

    cairo_rectangle(tmpctxt, 0, 0, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE);
    cairo_set_operator(tmpctxt, CAIRO_OPERATOR_SOURCE);
    cairo_fill(tmpctxt);

    cairo_destroy(tmpctxt);
};

class icCanvasManager::Cairo::Renderer::_DifferentialCurveFunctor {
        icCanvasManager::BrushStroke::__Spline::derivative_type& d;
    public:
        _DifferentialCurveFunctor(icCanvasManager::BrushStroke::__Spline::derivative_type& d) : d(d) {};
        float operator() (float t) {
            auto dpt = this->d.evaluate_for_point(t);
            auto deriv_len = sqrt((float)dpt.x * (float)dpt.x + (float)dpt.y * (float)dpt.y);

            return 1 / deriv_len;
        }
};

//Numerical factors required for Gauss-Legendre integration.
//The choice of 20 is motivated by the source examples for
//http://pomax.github.io/bezierinfo/ which consistently use 20 terms
static float gauss_weights[20] = {
    0.1527533871307258,
    0.1527533871307258,
    0.1491729864726037,
    0.1491729864726037,
    0.1420961093183820,
    0.1420961093183820,
    0.1316886384491766,
    0.1316886384491766,
    0.1181945319615184,
    0.1181945319615184,
    0.1019301198172404,
    0.1019301198172404,
    0.0832767415767048,
    0.0832767415767048,
    0.0626720483341091,
    0.0626720483341091,
    0.0406014298003869,
    0.0406014298003869,
    0.0176140071391521,
    0.0176140071391521
};

static float gauss_abscissae[20] = {
    -0.0765265211334973,
     0.0765265211334973,
    -0.2277858511416451,
     0.2277858511416451,
    -0.3737060887154195,
     0.3737060887154195,
    -0.5108670019508271,
     0.5108670019508271,
    -0.6360536807265150,
     0.6360536807265150,
    -0.7463319064601508,
     0.7463319064601508,
    -0.8391169718222188,
     0.8391169718222188,
    -0.9122344282513259,
     0.9122344282513259,
    -0.9639719272779138,
     0.9639719272779138,
    -0.9931285991850949,
     0.9931285991850949
};

float icCanvasManager::Cairo::Renderer::curve_arc_length(int polynomID, icCanvasManager::BrushStroke::__Spline::derivative_type &dt) {
    float sum = 0.0f;

    for (int i = 0; i < 20; i++) {
        float ct = (1.0/2.0) * gauss_abscissae[i] + (1.0/2.0);
        auto dtct = dt.evaluate_for_point(polynomID + ct);
        sum += gauss_weights[i] + sqrt((float)dtct.x * (float)dtct.x + (float)dtct.y * (float)dtct.y);
    }

    return (1.0/2.0) * sum;
};

void icCanvasManager::Cairo::Renderer::draw_stroke(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> br) {
    auto bbox = br->bounding_box();
    int32_t wx, wy, wx2, wy2, wx3, wy3, wx4, wy4;

    this->coord_to_tilespace(bbox.x, bbox.y, &wx, &wy);
    this->coord_to_tilespace(bbox.x + bbox.width, bbox.y + bbox.height, &wx2, &wy2);

    cairo_move_to(this->xrctxt, wx, wy);
    cairo_line_to(this->xrctxt, wx2, wy);
    cairo_line_to(this->xrctxt, wx2, wy2);
    cairo_line_to(this->xrctxt, wx, wy2);
    cairo_line_to(this->xrctxt, wx, wy);
    cairo_set_line_width(this->xrctxt, 1.0f);
    cairo_set_source_rgba(this->xrctxt, 1.0f, 0.0f, 1.0f, 1.0f);
    cairo_stroke(this->xrctxt);

    auto num_segments = br->count_segments();
    auto derivative = br->_curve.derivative();
    icCanvasManager::Cairo::Renderer::_DifferentialCurveFunctor diff(derivative);

    for (int i = 0; i < num_segments; i++) {
        auto length = this->curve_arc_length(i, derivative);
        int quality = (float)1.0 / this->xscale;

        auto testpt = derivative.evaluate_for_point(i);
        auto testlen = sqrt((float)testpt.x * (float)testpt.x + (float)testpt.y * (float)testpt.y);
        if (testlen == 0) {
            //Special case: If the derivative for this curve is zero,
            //don't try to draw the whole curve since the below code crahses.

            this->apply_brush(br, br->_curve.evaluate_for_point(i));
            continue;
        }

        for (float j = 0; j < length / this->xscale; j += quality) {
            int iterates = 5;
            float this_t = i;

            for (int k = 0; k < iterates; k++) {
                float step = j / iterates;

                if (this_t >= (i + 1)) {
                    this_t = i + 2;
                    break;
                }
                auto k1 = step * diff(this_t);

                auto t2 = this_t + (k1 / 2.0);
                if (t2 >= (i + 1)) {
                    this_t = i + 2;
                    break;
                }
                auto k2 = step * diff(t2);

                auto t3 = this_t + (k2 / 2.0);
                if (t3 >= (i + 1)) {
                    this_t = i + 2;
                    break;
                }
                auto k3 = step * diff(t3);

                auto t4 = this_t + k3;
                if (t4 >= (i + 1)) {
                    this_t = i + 2;
                    break;
                }
                auto k4 = step * diff(t4);

                this_t += (k1 + 2 * k2 + 2 * k3 + k4) / 6.0;
            }

            if (this_t >= (i + 1)) {
                //Our arclength function is currently broken, so bail out if we
                //are already off the edge of the polynomial.
                break;
            }

            this->apply_brush(br, br->_curve.evaluate_for_point(this_t));
        }
    }

    for (int i = 0; i < num_segments; i++) {
        this->coord_to_tilespace(br->_curve._storage[i]._pt[0].x, br->_curve._storage[i]._pt[0].y, &wx, &wy);
        this->coord_to_tilespace(br->_curve._storage[i]._pt[1].x, br->_curve._storage[i]._pt[1].y, &wx2, &wy2);
        this->coord_to_tilespace(br->_curve._storage[i]._pt[2].x, br->_curve._storage[i]._pt[2].y, &wx3, &wy3);
        this->coord_to_tilespace(br->_curve._storage[i]._pt[3].x, br->_curve._storage[i]._pt[3].y, &wx4, &wy4);

        cairo_move_to(this->xrctxt, wx, wy);
        cairo_curve_to(this->xrctxt, wx2, wy2, wx3, wy3, wx4, wy4);
        cairo_set_line_width(this->xrctxt, 1.0f);
        cairo_set_source_rgba(this->xrctxt, i & 0x1 ? 0.0f : 1.0f, 1.0f, i & 0x1 ? 1.0f : 0.0f, 1.0f);
        cairo_stroke(this->xrctxt);
    }

    for (auto i = br->_fitpts.begin(); i != br->_fitpts.end(); i++) {
        this->coord_to_tilespace(i->x, i->y, &wx, &wy);

        cairo_move_to(this->xrctxt, wx, wy);
        cairo_close_path(this->xrctxt);
        cairo_set_line_cap(this->xrctxt, CAIRO_LINE_CAP_ROUND);
        cairo_set_line_width(this->xrctxt, 5.0f);
        cairo_set_source_rgba(this->xrctxt, 0.0f, 1.0f, 1.0f, 1.0f);
        cairo_stroke(this->xrctxt);
    }
};

void icCanvasManager::Cairo::Renderer::apply_brush(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> br, const icCanvasManager::BrushStroke::__ControlPoint &cp) {
    //Hardcoded brush size and color
    uint32_t brush_size = br->brush_thickness();
    int brush_alpha = br->brush_opacity();
    int tint_red, tint_green, tint_blue;

    br->brush_tint(&tint_red, &tint_green, &tint_blue);

    auto brush_size_tspace = brush_size * this->xscale;
    cairo_set_source_rgba(this->xrctxt,
                          tint_red / (float)icCanvasManager::BrushStroke::COLOR_MAX,
                          tint_green / (float)icCanvasManager::BrushStroke::COLOR_MAX,
                          tint_blue / (float)icCanvasManager::BrushStroke::COLOR_MAX,
                          brush_alpha / (float)icCanvasManager::BrushStroke::COLOR_MAX / brush_size_tspace);

    int tx, ty;
    this->coord_to_tilespace(cp.x, cp.y, &tx, &ty);

    if ((0 - brush_size_tspace) > tx || tx >= (this->tw + brush_size_tspace)) return;
    if ((0 - brush_size_tspace) > ty || ty >= (this->th + brush_size_tspace)) return;

    cairo_new_path(this->xrctxt);
    cairo_arc(this->xrctxt, tx, ty, brush_size * this->xscale, 0, 2*3.14159);
    cairo_close_path(this->xrctxt);
    cairo_fill(this->xrctxt);
};
