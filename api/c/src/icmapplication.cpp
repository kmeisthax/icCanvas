#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

namespace icCanvasManager {
    class ApplicationDelegateCImpl : public Application::Delegate, public RefCnt {
        icm_application_delegate_hooks hooks;

    public:
        ApplicationDelegateCImpl(icm_application_delegate_hooks* hooks) : hooks(*hooks), RefCnt() {}
        virtual ~ApplicationDelegateCImpl() {
            if (this->hooks.enable_background_ticks_target_destroy_notify) {
                this->hooks.enable_background_ticks_target_destroy_notify(this->hooks.enable_background_ticks_context);
            }
            
            if (this->hooks.disable_background_ticks_target_destroy_notify) {
                this->hooks.disable_background_ticks_target_destroy_notify(this->hooks.disable_background_ticks_context);
            }
        }

        virtual void enable_background_ticks() override {
            if (this->hooks.enable_background_ticks) {
                this->hooks.enable_background_ticks(this->hooks.enable_background_ticks_context);
            }
        }

        virtual void disable_background_ticks() override {
            if (this->hooks.disable_background_ticks) {
                this->hooks.disable_background_ticks(this->hooks.disable_background_ticks_context);
            }
        }
    };
}

extern "C" {
    icm_application icm_application_get_instance() {
        icCanvasManager::Application *d = &icCanvasManager::Application::get_instance();
        return (icm_application)d;
    };

    icm_application icm_application_reference(icm_application wrap) {
        return wrap;
    };
    int icm_application_dereference(icm_application wrap) {
    };

    void icm_application_background_tick(icm_application w) {
        icCanvasManager::Application *d = (icCanvasManager::Application*)w;
        d->background_tick();
    };

    icm_renderscheduler icm_application_get_render_scheduler(icm_application w) {
        icCanvasManager::Application *d = (icCanvasManager::Application*)w;
        icCanvasManager::RenderScheduler *rs = d->get_render_scheduler();
        rs->ref();

        return (icm_renderscheduler)rs;
    };

    icm_application_delegate icm_application_delegate_reference(icm_application_delegate w) {
        icCanvasManager::Application::Delegate* d = (icCanvasManager::Application::Delegate*)w;
        icCanvasManager::RefCnt* d_refable = dynamic_cast<icCanvasManager::RefCnt*>(d_refable);

        if (d_refable) {
            d_refable->ref();
        }

        return w;
    };

    int icm_application_delegate_dereference(icm_application_delegate w) {
        icCanvasManager::Application::Delegate* d = (icCanvasManager::Application::Delegate*)w;
        icCanvasManager::RefCnt* d_refable = dynamic_cast<icCanvasManager::RefCnt*>(d);

        if (d_refable) {
            int refcount = d_refable->deref();

            if (refcount <= 0) {
                delete d;
            }

            return refcount;
        } else {
            return -1;
        }
    };

    icm_application_delegate icm_application_delegate_construct_custom(icm_application_delegate_hooks* hooks) {
        icCanvasManager::ApplicationDelegateCImpl* dcustom = new icCanvasManager::ApplicationDelegateCImpl(hooks);
        icCanvasManager::Application::Delegate* d = dcustom;
        dcustom->ref();

        return (void*)d;
    };

    bool icm_application_delegate_is_custom(icm_application_delegate w) {
        icCanvasManager::Application::Delegate* d = (icCanvasManager::Application::Delegate*)w;
        auto* dcustom = dynamic_cast<icCanvasManager::ApplicationDelegateCImpl*>(d);

        return dcustom != NULL;
    };

    void icm_application_set_delegate(icm_application w, icm_application_delegate w_del) {
        icCanvasManager::Application* d = (icCanvasManager::Application*)w;
        icCanvasManager::Application::Delegate* d_del = (icCanvasManager::Application::Delegate*)w_del;

        d->set_delegate(d_del);
    };

    icm_application_delegate icm_application_get_delegate(icm_application w) {
        icCanvasManager::Application* d = (icCanvasManager::Application*)w;

        return (void*)d->get_delegate();
    };

    //This code does nothing in particular that we care about, it's just there to get Vala to generate correct code
    void icm_application_delegate_hooks_destroy(icm_application_delegate_hooks* blargh) {

    };
}
