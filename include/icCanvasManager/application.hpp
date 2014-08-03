#ifndef __ICCANVASMANAGER__APPLICATION_HPP__
#define __ICCANVASMANAGER__APPLICATION_HPP__

#include <icCanvasManager.hpp>

namespace icCanvasManager {
    /* Represents objects and state intended to be shared about the application.
     */
    class Application : public Singleton<Application> {
        RefPtr<RenderScheduler> __scheduler;

        Application();
        ~Application();
    public:

        /* A function of which should be called periodically by frontend
         * event loops in order to perform background operations.
         */
        void background_tick();

        RefPtr<RenderScheduler> get_render_scheduler();

        friend Singleton<Application>;
    };
}

#endif
