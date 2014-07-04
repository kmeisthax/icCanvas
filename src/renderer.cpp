#include <icCanvasManager.hpp>
#include <iostream>

icCanvasManager::Renderer::Renderer():
    xrctxt(NULL), xrsurf(NULL) {
}

icCanvasManager::Renderer::~Renderer() {
    if (this->xrsurf) cairo_surface_destroy(this->xrsurf);
    if (this->xrctxt) cairo_destroy(this->xrctxt);
};

void icCanvasManager::Renderer::coordToTilespace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)(x - this->xmin) * this->xscale);
    if (out_ty) *out_ty = (int)((float)(y - this->ymin) * this->yscale);
};

void icCanvasManager::Renderer::applyBrush(const icCanvasManager::BrushStroke::__ControlPoint &cp) {
    //std::cerr << cp.x << "," << cp.y << std::endl;
    
    //Hardcoded brush size and color
    uint32_t brush_size = 4096;
    cairo_set_source_rgba(this->xrctxt, 0.0, 0.0, 0.0, 1.0);
    
    int tx, ty;
    this->coordToTilespace(cp.x, cp.y, &tx, &ty);

    if (0 > tx || tx >= this->tw) return;
    if (0 > ty || ty >= this->th) return;
    
    cairo_new_path(this->xrctxt);
    cairo_arc(this->xrctxt, tx, ty, brush_size * this->xscale, 0, 2*3.14159);
    cairo_close_path(this->xrctxt);
    cairo_fill(this->xrctxt);
};

void icCanvasManager::Renderer::enterSurface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf, const int height, const int width) {
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

void icCanvasManager::Renderer::enterImageSurface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf) {
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
};

void icCanvasManager::Renderer::enterContext(const int32_t x, const int32_t y, const int32_t zoom, cairo_t* xrctxt, const int height, const int width) {
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

void icCanvasManager::Renderer::drawStroke(icCanvasManager::BrushStroke& br) {
    auto num_segments = br.count_segments();
    
    for (int i = 0; i < num_segments; i++) {
        this->applyBrush(br._curve.evaluate_for_point(i + 0.0));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.125));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.25));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.375));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.50));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.625));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.75));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.875));
        this->applyBrush(br._curve.evaluate_for_point(i + 0.999));
    }
};
