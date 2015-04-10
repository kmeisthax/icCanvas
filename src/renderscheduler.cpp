#include <icCanvasManager.hpp>

icCanvasManager::RenderScheduler::RenderScheduler(icCanvasManager::Application* app) {
    this->_renderer = new icCanvasManager::CairoRenderer();
    this->_app = app;
};

icCanvasManager::Renderer* icCanvasManager::RenderScheduler::renderer() {
    return this->_renderer;
};

void icCanvasManager::RenderScheduler::set_renderer(icCanvasManager::RefPtr<icCanvasManager::Renderer> r) {
    this->_renderer = r;
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

    for (auto i = this->_unrendered.begin(); i != this->_unrendered.end(); i++) {
        if (i->x == x && i->y == y && i->size == size && i->time == time) {
            return;
        }
    }

    icCanvasManager::RenderScheduler::__Request r = {d, x, y, size, time};
    this->_unrendered.push_back(r);

    this->_app->add_tasks(1);
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
    int x_tile_count = std::ceil(rect.width / (float)request_size) + 1;
    int y_tile_count = std::ceil(rect.height / (float)request_size) + 1;

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

void icCanvasManager::RenderScheduler::revoke_request(icCanvasManager::RefPtr<icCanvasManager::Drawing> d, int x_min, int y_min, int x_max, int y_max, bool is_inverse) {
    int revokecnt = 0;

    for (auto i = this->_unrendered.begin(); i != this->_unrendered.end(); i++) {
        unsigned int tile_manhattan_diameter = (UINT32_MAX >> i->size) / 2;
        auto adjust_x_min = x_min, adjust_x_max = x_max, adjust_y_min = y_min, adjust_y_max = y_max;
        if (adjust_x_min > INT32_MIN + tile_manhattan_diameter) adjust_x_min -= tile_manhattan_diameter;
        else adjust_x_min = INT32_MIN;
        if (adjust_x_max < INT32_MAX - tile_manhattan_diameter) adjust_x_max += tile_manhattan_diameter;
        else adjust_x_max = INT32_MAX;
        if (adjust_y_min > INT32_MIN + tile_manhattan_diameter) adjust_y_min -= tile_manhattan_diameter;
        else adjust_y_min = INT32_MIN;
        if (adjust_y_max < INT32_MAX - tile_manhattan_diameter) adjust_y_max += tile_manhattan_diameter;
        else adjust_y_max = INT32_MAX;

        bool in_rect = i->d == d &&
            i->x >= adjust_x_min && i->x < adjust_x_max &&
            i->y >= adjust_y_min && i->y < adjust_y_max;

        if (in_rect || (is_inverse && !in_rect)) {
            revokecnt++;

            i = this->_unrendered.erase(i);
            if (i == this->_unrendered.end()) break;
        }
    }

    this->_app->complete_tasks(revokecnt);
};

void icCanvasManager::RenderScheduler::revoke_request(icCanvasManager::RefPtr<icCanvasManager::Drawing> d, int zoom_min, int zoom_max, bool is_inverse) {
    int revokecnt = 0;

    for (auto i = this->_unrendered.begin(); i != this->_unrendered.end(); i++) {
        bool is_bad_zoom = i->size >= zoom_min && i->size < zoom_max;

        if (is_bad_zoom || (is_inverse && !is_bad_zoom)) {
            revokecnt++;

            i = this->_unrendered.erase(i);
            if (i == this->_unrendered.end()) break;
        }
    }
    this->_app->complete_tasks(revokecnt);
};

void icCanvasManager::RenderScheduler::background_tick() {
    int tick_request_limit = 1, rendered_requests = 0;

    while (this->_unrendered.size() > 0 && rendered_requests < tick_request_limit) {
        auto req = this->_unrendered.back();

        this->_renderer->enter_new_surface(req.x, req.y, req.size);

        for (int i = 0; i < req.time; i++) {
            this->_renderer->draw_stroke(req.d->stroke_at_time(i));
        }

        cairo_surface_t* imgsurf = this->_renderer->retrieve_image_surface();
        if (imgsurf == NULL) {
            cairo_surface_t* imgsurf = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE);
            this->_renderer->transfer_to_image_surface(imgsurf);
        }

        cairo_surface_reference(imgsurf);

        icCanvasManager::RenderScheduler::__Response r = {req.d, req.x, req.y, req.size, req.time, imgsurf};
        this->_unrendered.pop_back();
        this->_uncollected.push_back(r);

        rendered_requests++;
    }

    this->_app->complete_tasks(rendered_requests);
};

int icCanvasManager::RenderScheduler::collect_request(icCanvasManager::RefPtr<icCanvasManager::Drawing> d, cairo_rectangle_t *out_tile_rect) {
    int count = 0;

    auto i = this->_uncollected.begin();
    while (i != this->_uncollected.end()) {
        if (i->d == d) {
            d->get_tilecache()->store(i->x, i->y, i->size, i->time, i->tile);
            cairo_surface_destroy(i->tile);
            i = this->_uncollected.erase(i);

            if (out_tile_rect) {
                int size_canvas_units = (UINT32_MAX >> i->size) + 1;

                out_tile_rect->x = i->x - size_canvas_units / 2.0f;
                out_tile_rect->y = i->y - size_canvas_units / 2.0f;
                out_tile_rect->width = size_canvas_units;
                out_tile_rect->height = size_canvas_units;
            }

            count++;
            return count;
        } else {
            i++;
        }
    }

    return count;
};
