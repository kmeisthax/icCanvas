#include <icCanvasManager.hpp>

//icCanvasManager::ZoomTool::

icCanvasManager::ZoomTool::ZoomTool() : _is_tracking_zoom(false) {
}

icCanvasManager::ZoomTool::~ZoomTool() {
}

void icCanvasManager::ZoomTool::prepare_for_reuse() {
    this->_is_tracking_click = false;
    this->_is_tracking_zoom = false;
    this->_initial_x = 0;
    this->_initial_y = 0;
    this->_breaking_x = 0;
    this->_breaking_y = 0;
};

void icCanvasManager::ZoomTool::set_size(const double width, const double height, const double ui_scale, const double zoom) {
    icCanvasManager::CanvasTool::set_size(width, height, ui_scale, zoom);
};

/* Event handling */
void icCanvasManager::ZoomTool::mouse_down(const double x, const double y, const double deltaX, const double deltaY) {
    this->_is_tracking_click = true;
    this->_initial_x = x;
    this->_initial_y = y;
    this->_breaking_x = x;
    this->_breaking_y = y;

    this->_window_zoom(&this->_initial_zoom);
    this->_canvas_centerpt(&this->_initial_scroll_x, &this->_initial_scroll_y);
    this->_window_to_coordspace(x, y, &this->_target_scroll_x, &this->_target_scroll_y);
};

void icCanvasManager::ZoomTool::mouse_drag(const double x, const double y, const double deltaX, const double deltaY) {
    if (this->_is_tracking_click) {
        double distance = sqrt(pow(x - this->_initial_x, 2.0f) + pow(y - this->_initial_y, 2.0f));

        if (distance > 15.0f) {
            this->_is_tracking_click = false;
            this->_is_tracking_zoom = true;
            this->_breaking_x = x;
            this->_breaking_y = y;
        }
    }

    if (this->_is_tracking_zoom) {
        //Drags to the left accomplish zoom-out.
        //Drags to the right accomplish zoom-in.
        double initial_dist = this->_breaking_x - this->_initial_x;
        double current_dist = x - this->_initial_x;
        double zoom_factor = this->_breaking_x < this->_initial_x ? current_dist / initial_dist : initial_dist / current_dist;

        if (zoom_factor <= 0) return;

        int pixel_zoom_factor = this->_initial_zoom * zoom_factor;

        double counterscroll_x = (this->_target_scroll_x - this->_initial_scroll_x) - (this->_target_scroll_x - this->_initial_scroll_x) * zoom_factor;
        double counterscroll_y = (this->_target_scroll_y - this->_initial_scroll_y) - (this->_target_scroll_y - this->_initial_scroll_y) * zoom_factor;

        if (this->_delegate)
            this->_delegate->changed_scroll_and_zoom(this->_initial_scroll_x + counterscroll_x,
                                                     this->_initial_scroll_y + counterscroll_y,
                                                     pixel_zoom_factor);
    }
};

void icCanvasManager::ZoomTool::mouse_up(const double x, const double y, const double deltaX, const double deltaY) {
    this->_is_tracking_zoom = false;
    this->_is_tracking_click = false;
};

/* Required by C++ law */
icCanvasManager::ZoomToolDelegate::~ZoomToolDelegate() {
};
