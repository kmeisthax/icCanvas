#ifndef __ICCANVASMANAGER__APPLICATION_HPP__
#define __ICCANVASMANAGER__APPLICATION_HPP__

#include <icCanvasManager.hpp>

namespace icCanvasManager {
    /* Represents a platform-specific object responsible for responding to
     * high-level application maintenance requests.
     */
    class ApplicationDelegate {
    public:
        virtual ~ApplicationDelegate();

        /* Called when the Application has work to do on background_tick. */
        virtual void enable_background_ticks() = 0;
        /* Called when the Application is finished with work on the
         * background_tick function.
         *
         * Calling background_tick again is possible, however, it will be a
         * waste of energy.
         */
        virtual void disable_background_ticks() = 0;
    };

    /* Represents objects and state intended to be shared about the application.
     */
    class Application : public Singleton<Application>, public Delegator<Application, ApplicationDelegate> {
    public:
        typedef ApplicationDelegate Delegate;
    private:
        RefPtr<RenderScheduler> __scheduler;

        Application();
        ~Application();

        int _taskcnt;
    public:

        /* A function of which should be called periodically by frontend
         * event loops in order to perform background operations.
         */
        void background_tick();

        /* The TaskCount is used to indicate when to enable or disable ticks */
        void add_tasks(int howmany);
        void complete_tasks(int howmany);

        RefPtr<RenderScheduler> get_render_scheduler();

        friend Singleton<Application>;
    };
}

#endif
