#include <icCanvasManager.hpp>

icCanvasManager::CanvasView::CanvasView() {
    this->renderer = new icCanvasManager::Renderer();
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

    this->renderer->enterContext(0, 0, 14, ctxt, this->height, this->width);

    for (; strokePtr != end; strokePtr++) {
        this->renderer->drawStroke(*strokePtr);
    }

    cairo_restore(ctxt);
};

void icCanvasManager::CanvasView::set_size(double width, double height) {
    this->width = width;
    this->height = height;
};
