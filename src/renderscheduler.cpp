#include <icCanvasManager.hpp>

icCanvasManager::RenderScheduler::RenderScheduler() {
    this->_renderer = new icCanvasManager::Renderer();
};

icCanvasManager::RenderScheduler::~RenderScheduler() {
    for (auto i = this->_uncollected.begin(); i != this->_uncollected.end(); i++) {
        if (i->tile) cairo_surface_destroy(i->tile);
    }
};

void icCanvasManager::RenderScheduler::request_tile(icCanvasManager::RefPtr<icCanvasManager::Drawing> d, int x, int y, int size, int time) {
    if (d->get_tilecache()->lookup(x, y, size, time) != -1) {
        return;
    }

    icCanvasManager::RenderScheduler::__Request r = {d, x, y, size, time};
    this->_unrendered.push_back(r);
};

void icCanvasManager::RenderScheduler::request_tiles(icCanvasManager::RefPtr<icCanvasManager::Drawing> d, cairo_rectangle_t rect, int size, int time) {
    if (size < 0) {
        size = 0;
    }

    //Special-case for zoom factor 0 because I can't be arsed to deal with overflow crap
    if (size == 0) {
        this->request_tile(d, 0, 0, 0, time);
        return;
    }

    int request_size = (UINT32_MAX >> size) + 1;
    int rect_x_scroll = rect.x;
    int rect_y_scroll = rect.y;
    int base_x = rect_x_scroll - rect_x_scroll % request_size - (request_size / 2);
    int base_y = rect_y_scroll - rect_y_scroll % request_size - (request_size / 2);
    int x_tile_count = std::ceil(rect.width / (float)request_size);
    int y_tile_count = std::ceil(rect.height / (float)request_size);

    for (int i = 0; i <= x_tile_count; i++) {
        for (int j = 0; j <= y_tile_count; j++) {
            //Don't request out-of-bounds tiles.
            //This is complicated by the fact that C integer behaviors blow chunks.
            if ((int)request_size != 0) { //Intel divide-by-zero behavior ALSO blows chunks.
                if ((INT32_MAX / (int)request_size) < i) continue;
                if ((INT32_MAX / (int)request_size) < j) continue;
            }
            if ((base_x > 0) && (base_x > INT32_MAX - ((int)request_size * i))) continue;
            if ((base_y > 0) && (base_y > INT32_MAX - ((int)request_size * j))) continue;

            this->request_tile(d, base_x + ((int)request_size * i), base_y + ((int)request_size * j), size, time);
        }
    }
};

void icCanvasManager::RenderScheduler::revoke_request(icCanvasManager::RefPtr<icCanvasManager::Drawing> d, int x_min, int y_min, int x_max, int y_max) {
    for (auto i = this->_unrendered.begin(); i != this->_unrendered.end(); i++) {
        int tile_manhattan_diameter = (UINT32_MAX >> i->size) / 2;
        if (i->d == d &&
            i->x >= (x_min - tile_manhattan_diameter) && i->x < (x_max + tile_manhattan_diameter) &&
            i->y >= (y_min - tile_manhattan_diameter) && i->y < (y_max + tile_manhattan_diameter)) {
            i = this->_unrendered.erase(i);
        }
    }
};

void icCanvasManager::RenderScheduler::background_tick() {
    int tick_request_limit = 1, rendered_requests = 0;

    while (this->_unrendered.size() > 0 && rendered_requests < tick_request_limit) {
        auto req = this->_unrendered.back();

        cairo_surface_t* imgsurf = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE);
        cairo_surface_reference(imgsurf);

        this->_renderer->enterImageSurface(req.x, req.y, req.size, imgsurf);

        for (int i = 0; i < req.time; i++) {
            this->_renderer->drawStroke(req.d->stroke_at_time(i));
        }

        icCanvasManager::RenderScheduler::__Response r = {req.d, req.x, req.y, req.size, req.time, imgsurf};
        this->_unrendered.pop_back();
        this->_uncollected.push_back(r);

        rendered_requests++;
    }
};

int icCanvasManager::RenderScheduler::collect_requests(icCanvasManager::RefPtr<icCanvasManager::Drawing> d) {
    int count = 0;

    auto i = this->_uncollected.begin();
    while (i != this->_uncollected.end()) {
        if (i->d == d) {
            d->get_tilecache()->store(i->x, i->y, i->size, i->time, i->tile);
            cairo_surface_destroy(i->tile);
            i = this->_uncollected.erase(i);

            count++;
        } else {
            i++;
        }
    }

    return count;
};
