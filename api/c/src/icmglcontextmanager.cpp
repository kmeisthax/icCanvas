#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

namespace icCanvasManager {
    namespace GL {
        class CAPIContextManager : public virtual ContextManager {
            icm_gl_contextmanager_hooks hk;
        public:
            CAPIContextManager(icm_gl_contextmanager_hooks hk) : hk(hk) {};
            virtual ~CAPIContextManager() override {
                if (this->hk.create_main_context_destroy_notify) {
                    this->hk.create_main_context_destroy_notify(this->hk.create_main_context_context);
                }

                if (this->hk.create_sub_context_destroy_notify) {
                    this->hk.create_sub_context_destroy_notify(this->hk.create_sub_context_context);
                }

                if (this->hk.shutdown_sub_context_destroy_notify) {
                    this->hk.shutdown_sub_context_destroy_notify(this->hk.shutdown_sub_context_context);
                }

                if (this->hk.make_current_destroy_notify) {
                    this->hk.make_current_destroy_notify(this->hk.make_current_context);
                }
            };

            CONTEXT create_main_context(int major, int minor) {
                return this->hk.create_main_context(major, minor, this->hk.create_main_context_context);
            };

            CONTEXT create_sub_context() {
                return this->hk.create_sub_context(this->hk.create_sub_context_context);
            };

            void shutdown_sub_context(CONTEXT ctxt) {
                return this->hk.shutdown_sub_context(ctxt, this->hk.shutdown_sub_context_context);
            };

            CONTEXT make_current(CONTEXT ctxt, DRAWABLE drawable) {
                return this->hk.make_current(ctxt, drawable, this->hk.make_current_context);
            };
        };
    };
};

extern "C" {
    icm_gl_contextmanager icm_gl_contextmanager_reference(icm_gl_contextmanager wrap) {
        icCanvasManager::GL::ContextManager *d = (icCanvasManager::GL::ContextManager*)wrap;
        d->ref();

        return wrap;
    };

    int icm_gl_contextmanager_dereference(icm_gl_contextmanager wrap) {
        icCanvasManager::GL::ContextManager *d = (icCanvasManager::GL::ContextManager*)wrap;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_gl_contextmanager icm_gl_contextmanager_construct_custom(icm_gl_contextmanager_hooks hookslist) {
        auto *dcustom = new icCanvasManager::GL::CAPIContextManager(hookslist);
        icCanvasManager::GL::ContextManager *d = dcustom;
        dcustom->ref();

        return (void*)d;
    };

    //This code does nothing in particular that we care about, it's just there to get Vala to generate correct code
    void icm_gl_contextmanager_hooks_destroy(icm_gl_contextmanager_hooks* blargh) {

    };
}
