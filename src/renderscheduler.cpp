#include <icCanvasManager.hpp>

icCanvasManager::RenderScheduler::

icCanvasManager::RenderScheduler::RenderScheduler() {
    this->_renderer = new icCanvasManager::Renderer();
};

icCanvasManager::RenderScheduler::~RenderScheduler() {
    for (auto i = this->_uncollected.begin(); i != this->_uncollected.end(); i++) {
        if (i->tile) cairo_surface_destroy(i->tile);
    }
};

icCanvasManager::RenderScheduler::request_tile(icCanvasManager::RefPtr<icCanvasManager::Drawing> d, int x, int y, int size, int time) {
    cairo_surface_t* imgsurf = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE);

    this->_renderer->enter_image_surface(x, y, size, imgsurf);

    for (int i = 0; i < time; i++) {
        this->_renderer->draw_stroke(d->stroke_at_time(i));
    }
};

icCanvasManager::RenderScheduler::collect_requests(icCanvasManager::RefPtr<icCanvasManager::Drawing> d) {
    auto i = this->_uncollected.begin();
    while (i != this->_uncollected.end()) {
        if (i->d == d) {
            d->cache->store(i->x, i->y, i->size, i->time, i->tile);
            i = this->_uncollected.erase(i);
        } else {
            i++;
        }
    }
};
