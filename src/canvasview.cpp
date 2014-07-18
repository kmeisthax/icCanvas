#include <icCanvasManager.hpp>

icCanvasManager::CanvasView::CanvasView() {
    this->renderer = new icCanvasManager::Renderer();
    this->fitter = new icCanvasManager::SplineFitter();

    this->x_center = 0;
    this->y_center = 0;
    this->zoom = 14;
};

icCanvasManager::CanvasView::~CanvasView() {};

void icCanvasManager::CanvasView::attach_drawing(icCanvasManager::RefPtr<icCanvasManager::Drawing> drawing) {
    this->drawing = drawing;
};

void icCanvasManager::CanvasView::draw(cairo_t *ctxt, cairo_rectangle_t dirtyArea) {
    auto strokePtr = this->drawing->begin(), end = this->drawing->end();
    auto clear_ptn = cairo_pattern_create_rgb(1.0f, 1.0f, 1.0f);

    cairo_save(ctxt);
    cairo_set_source(ctxt, clear_ptn);
    cairo_paint(ctxt);
    cairo_pattern_destroy(clear_ptn);

    this->renderer->enterContext(this->x_center, this->y_center, (int)this->zoom, ctxt, this->height, this->width);

    for (; strokePtr != end; strokePtr++) {
        this->renderer->drawStroke(*strokePtr);
    }

    cairo_restore(ctxt);
};

void icCanvasManager::CanvasView::set_size(double width, double height) {
    this->width = width;
    this->height = height;

    int64_t size = UINT32_MAX >> (int)this->zoom;
    this->x_scale = this->width / (float)size;
    this->y_scale = this->height / (float)size;
    this->x_scroll = this->x_center - (width / this->x_scale / 2);
    this->y_scroll = this->y_center - (height / this->y_scale / 2);
};

void icCanvasManager::CanvasView::windowToCoordspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)x / this->x_scale + this->x_scroll);
    if (out_ty) *out_ty = (int)((float)y / this->y_scale + this->y_scroll);
};

void icCanvasManager::CanvasView::mouse_down(int x, int y, int deltaX, int deltaY) {
    this->built_stroke = new icCanvasManager::BrushStroke();
    this->fitter->begin_fitting(this->built_stroke, 0);
};

void icCanvasManager::CanvasView::mouse_drag(int x, int y, int deltaX, int deltaY) {
    int cx, cy, cdx = deltaX / this->x_scale, cdy = deltaY / this->y_scale;

    this->windowToCoordspace(x, y, &cx, &cy);
    this->fitter->add_fit_point(cx, cy, icCanvasManager::BrushStroke::PRESSURE_MAX, 0, 0, cdx, cdy);
};

void icCanvasManager::CanvasView::mouse_up(int x, int y, int deltaX, int deltaY) {
    this->fitter->finish_fitting();
    this->drawing->append_stroke(this->built_stroke);
    this->built_stroke = NULL;
};
