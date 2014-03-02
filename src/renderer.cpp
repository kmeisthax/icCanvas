#include <icCanvasManager.hpp>

void icCanvasManager::Renderer::coordToTilespace(int32_t x, int32_t y, int32_t* out_tx, int32_t* out_ty) {
    
};

void icCanvasManager::Renderer::enterSurface(int32_t x, int32_t y, int32_t zoom, cairo_surface_t* xrsurf) {
    this->x = x;
    this->y = y;
    this->zoom = zoom;
    this->xrsurf = xrsurf;
    
    this->w = cairo_image_surface_get_width(this->xrsurf);
    this->h = cairo_image_surface_get_height(this->xrsurf);
};