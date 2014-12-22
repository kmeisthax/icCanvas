#include <icCanvasManager.hpp>

icCanvasManager::CanvasTool::CanvasTool() {};
icCanvasManager::CanvasTool::~CanvasTool() {};

void icCanvasManager::CanvasTool::_window_size(double *width, double *height) {
    if (width) *width = this->_width;
    if (height) *height = this->_height;
};

void icCanvasManager::CanvasTool::_window_zoom(double *zoom) {
    if (zoom) *zoom = this->_zoom;
};

void icCanvasManager::CanvasTool::_window_to_coordspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)x * this->_zoom + this->_x_scroll);
    if (out_ty) *out_ty = (int)((float)y * this->_zoom + this->_y_scroll);
};

void icCanvasManager::CanvasTool::_coord_to_windowspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)(x - this->_x_scroll) / this->_zoom);
    if (out_ty) *out_ty = (int)((float)(y - this->_y_scroll) / this->_zoom);
};

void icCanvasManager::CanvasTool::_window_to_coordvector(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)x * this->_zoom);
    if (out_ty) *out_ty = (int)((float)y * this->_zoom);
};

void icCanvasManager::CanvasTool::_coord_to_windowvector(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty) {
    if (out_tx) *out_tx = (int)((float)(x) / this->_zoom);
    if (out_ty) *out_ty = (int)((float)(y) / this->_zoom);
};

void icCanvasManager::CanvasTool::set_size(const double width, const double height, const double ui_scale, const double zoom) {
    this->_width = width;
    this->_height = height;
    this->_ui_scale = ui_scale;
    this->_zoom = zoom;

    this->_x_size = this->_width * this->_zoom;
    this->_y_size = this->_height * this->_zoom;
    this->_x_scroll = this->_x_center - (width * this->_zoom / 2.0);
    this->_y_scroll = this->_y_center - (height * this->_zoom / 2.0);
};

void icCanvasManager::CanvasTool::set_scroll_center(const double x, const double y) {
    this->_x_center = x * this->_zoom;
    this->_y_center = y * this->_zoom;

    this->_x_scroll = this->_x_center - (this->_width * this->_zoom / 2.0);
    this->_y_scroll = this->_y_center - (this->_height * this->_zoom / 2.0);
};
