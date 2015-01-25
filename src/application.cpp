#include <icCanvasManager.hpp>

icCanvasManager::Application::Application() : _taskcnt(0) {
    this->__scheduler = new icCanvasManager::RenderScheduler(this);
};
icCanvasManager::Application::~Application() {};

void icCanvasManager::Application::background_tick() {
    this->get_render_scheduler()->background_tick();
};

icCanvasManager::RefPtr<icCanvasManager::RenderScheduler> icCanvasManager::Application::get_render_scheduler() {
    return this->__scheduler;
};

void icCanvasManager::Application::add_tasks(int howmany) {
    this->_taskcnt += howmany;

    if (this->_delegate && this->_taskcnt > 0) {
        this->_delegate->enable_background_ticks();
    }
};
void icCanvasManager::Application::complete_tasks(int howmany) {
    this->_taskcnt -= howmany;

    if (this->_delegate && this->_taskcnt <= 0) {
        this->_delegate->disable_background_ticks();
    }
};

icCanvasManager::ApplicationDelegate::~ApplicationDelegate() {};
