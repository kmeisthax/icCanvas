#include <icCanvasManager.hpp>

void icCanvasManager::Renderer::coordToTilespace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)(x - this->xmin) * this->xscale);
    if (out_ty) *out_ty = (int)((float)(y - this->ymin) * this->yscale);
};

void icCanvasManager::Renderer::enterImageSurface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf) {
    this->x = x;
    this->y = y;
    this->zoom = std::max(zoom, 31);
    this->xrsurf = xrsurf;
    
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
