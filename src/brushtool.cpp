#include <icCanvasManager.hpp>

//icCanvasManager::BrushTool::

icCanvasManager::BrushTool::BrushTool() : _error_threshold(0), _fitter(new icCanvasManager::SplineFitter()) {
}

icCanvasManager::BrushTool::~BrushTool() {
}

void icCanvasManager::BrushTool::prepare_for_reuse() {
    this->_fitter->prepare_for_reuse();

    this->_is_fitting = false;
    this->_built_stroke = NULL;
};

void icCanvasManager::BrushTool::set_size(const double width, const double height, const double ui_scale, const double zoom) {
    this->_error_threshold = 5 * zoom;
    icCanvasManager::CanvasTool::set_size(width, height, ui_scale, zoom);
};

/* Event handling */
void icCanvasManager::BrushTool::mouse_down(const double x, const double y, const double deltaX, const double deltaY) {
    this->_is_fitting = true;
    this->_built_stroke = new icCanvasManager::BrushStroke();

    double z;
    this->_window_zoom(&z);
    this->_built_stroke->set_brush_thickness(z * 10);

    this->_fitter->begin_fitting(this->_built_stroke, this->_error_threshold);
};

void icCanvasManager::BrushTool::mouse_drag(const double x, const double y, const double deltaX, const double deltaY) {
    if (this->_is_fitting) {
        int cx, cy, cdx, cdy;

        this->_window_to_coordspace(x, y, &cx, &cy);
        this->_window_to_coordvector(deltaX, deltaY, &cdx, &cdy);
        this->_fitter->add_fit_point(cx, cy, icCanvasManager::BrushStroke::PRESSURE_MAX, 0, 0, cdx, cdy);
    }
};

void icCanvasManager::BrushTool::mouse_up(const double x, const double y, const double deltaX, const double deltaY) {
    if (this->_is_fitting) {
        this->_fitter->finish_fitting();
        if (this->_delegate) this->_delegate->captured_stroke(this->_built_stroke);
        this->prepare_for_reuse();
    }
};

/* Required by C++ law */
icCanvasManager::BrushToolDelegate::~BrushToolDelegate() {
};
