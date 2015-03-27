#include <icCanvasManager.hpp>
#include <cmath>
#include <iostream>

icCanvasManager::Renderer::Renderer() {
}

icCanvasManager::Renderer::~Renderer() {
};

void icCanvasManager::Renderer::coord_to_tilespace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)(x - this->xmin) * this->xscale);
    if (out_ty) *out_ty = (int)((float)(y - this->ymin) * this->yscale);
};

cairo_surface_t* icCanvasManager::Renderer::retrieve_image_surface() {
    return NULL;
};
