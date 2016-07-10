#include <icCanvasManager.hpp>

#include <iostream>
#include <fstream>
#include <cmath>

icCanvasManager::CPU::Renderer::Renderer() {};

icCanvasManager::CPU::Renderer::~Renderer() {};

void icCanvasManager::CPU::Renderer::enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) {
    this->x = x;
    this->y = y;
    this->zoom = std::min(zoom, 31);

    this->tw = icCanvasManager::TileCache::TILE_SIZE;
    this->th = icCanvasManager::TileCache::TILE_SIZE;

    int64_t size = UINT32_MAX >> this->zoom;
    this->xmin = x - (size >> 1);
    this->ymin = y - (size >> 1);

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

};

icCanvasManager::DisplaySuiteTILE icCanvasManager::CPU::Renderer::copy_to_tile() {
};
