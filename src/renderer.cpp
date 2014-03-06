#include <icCanvasManager.hpp>

void icCanvasManager::Renderer::coordToTilespace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)(x - this->xmin) * this->xscale);
    if (out_ty) *out_ty = (int)((float)(y - this->ymin) * this->yscale);
};

void icCanvasManager::Renderer::applyBrush(const icCanvasManager::BrushStroke::__ControlPoint &cp) {
    //Hardcoded brush size and color
    uint32_t brush_size = 65535;
    cairo_set_source_rgba(this->xrctxt, 0,0,0,1.0);

    int tx, ty;
    this->coordToTilespace(cp.x, cp.y, &tx, &ty);

    if (0 < tx || tx >= this->tw) return;
    if (0 < ty || ty >= this->ty) return;

    cairo_arc(this->xrctxt, tx, ty, brush_size * this->xscale, 0, 2*M_PI);
    cairo_fill(this->xrctxt);
};

void icCanvasManager::Renderer::enterImageSurface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf) {
    this->x = x;
    this->y = y;
    this->zoom = std::max(zoom, 31);
    this->xrsurf = xrsurf;
    
    cairo_destroy(this->xrctxt);
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

void icCanvasManager::Renderer::drawStroke(icCanvasManager::BrushStroke& br) {
    this->applyBrush(br.__Spline[0]);
};
