#include <icCanvasManager.hpp>

icCanvasManager::CanvasTool::CanvasTool() {};
icCanvasManager::CanvasTool::~CanvasTool() {};

//void icCanvasManager::CanvasTool::prepare_for_reuse() = 0;
//void set_size(const double width, const double height, const double ui_scale, const double zoom) = 0;

void icCanvasManager::CanvasTool::mouse_down(const double x, const double y, const double deltaX, const double deltaY) {};
void icCanvasManager::CanvasTool::mouse_drag(const double x, const double y, const double deltaX, const double deltaY) {};
void icCanvasManager::CanvasTool::mouse_up(const double x, const double y, const double deltaX, const double deltaY) {};
