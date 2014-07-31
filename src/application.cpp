#include <icCanvasManager.hpp>

icCanvasManager::Application

icCanvasManager::Application::Application() {
    this->__scheduler = new icCanvasManager::RenderScheduler();
};
icCanvasManager::Application::~Application() {};

void icCanvasManager::Application::background_tick() {
    this->get_render_scheduler()->background_tick();
};

icCanvasManager::RefPtr<icCanvasManager::RenderScheduler> icCanvasManager::Application::get_render_scheduler() {
    return this->__scheduler;
};
