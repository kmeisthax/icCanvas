#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

extern "C" {
    icm_application icm_application_get_instance() {
        icCanvasManager::Application *d = &icCanvasManager::Application::get_instance();
        return (icm_application)d;
    };

    void icm_application_background_tick(icm_application w) {
        icCanvasManager::Application *d = (icCanvasManager::Application*)w;
        d->background_tick();
    };

    icm_renderscheduler icm_application_get_render_scheduler(icm_application w) {
        icCanvasManager::Application *d = (icCanvasManager::Application*)w;
        icCanvasManager::RenderScheduler *rs = d->get_render_scheduler();

        return (icm_renderscheduler)rs;
    };
}
