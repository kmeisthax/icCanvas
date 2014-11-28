#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

namespace icCanvasManager {
    class BrushToolDelegateCImpl : public BrushTool::Delegate, public RefCnt {
        icm_brushtool_delegate_hooks hooks;

    public:
        BrushToolDelegateCImpl(icm_brushtool_delegate_hooks* hooks) : hooks(*hooks) {}
        virtual ~BrushToolDelegateCImpl() {
            if (this->hooks.captured_stroke_target_destroy_notify) {
                this->hooks.captured_stroke_target_destroy_notify(this->hooks.captured_stroke_context);
            }
        }

        virtual void captured_stroke(RefPtr<BrushStroke> stroke) {
            if (this->hooks.captured_stroke) {
                BrushStroke* bs = stroke;
                this->hooks.captured_stroke((void*)bs, this->hooks.captured_stroke_context);
            }
        }
    };
}

extern "C" {
    icm_brushtool icm_brushtool_construct() {
        icCanvasManager::BrushTool* d = new icCanvasManager::BrushTool();
        d->ref();

        return (icm_brushtool)d;
    };

    int icm_brushtool_reference(icm_brushtool w) {
        icCanvasManager::BrushTool* d = (icCanvasManager::BrushTool*)w;
        return d->ref();
    };

    int icm_brushtool_dereference(icm_brushtool w) {
        icCanvasManager::BrushTool* d = (icCanvasManager::BrushTool*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_brushtool icm_brushtool_downcast(icm_canvastool up_obj) {
        icCanvasManager::CanvasTool* up = (icCanvasManager::CanvasTool*)up_obj;
        icCanvasManager::BrushTool* down = dynamic_cast<icCanvasManager::BrushTool*>(up);

        return (void*)down;
    };

    icm_canvastool icm_brushtool_upcast(icm_brushtool down_obj) {
        icCanvasManager::BrushTool* down = (icCanvasManager::BrushTool*)down_obj;
        icCanvasManager::CanvasTool* up = static_cast<icCanvasManager::CanvasTool*>(down);

        return (void*)up;
    };

    int icm_brushtool_delegate_reference(icm_brushtool_delegate w) {
        icCanvasManager::BrushTool::Delegate* d = (icCanvasManager::BrushTool::Delegate*)w;
        icCanvasManager::RefCnt* d_refable = dynamic_cast<icCanvasManager::RefCnt*>(d_refable);

        if (d_refable) {
            return d_refable->ref();
        } else {
            return -1;
        }
    };

    int icm_brushtool_delegate_dereference(icm_brushtool_delegate w) {
        icCanvasManager::BrushTool::Delegate* d = (icCanvasManager::BrushTool::Delegate*)w;
        icCanvasManager::RefCnt* d_refable = dynamic_cast<icCanvasManager::RefCnt*>(d_refable);

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

    icm_brushtool_delegate icm_brushtool_delegate_construct_custom(icm_brushtool_delegate_hooks* hooks) {
        auto* dcustom = new icCanvasManager::BrushToolDelegateCImpl(hooks);
        auto* d = static_cast<icCanvasManager::BrushTool::Delegate*>(dcustom);

        return (void*)d;
    };

    bool icm_brushtool_delegate_is_custom(icm_brushtool_delegate w) {
        icCanvasManager::BrushTool::Delegate* d = (icCanvasManager::BrushTool::Delegate*)w;
        auto* dcustom = dynamic_cast<icCanvasManager::BrushToolDelegateCImpl*>(d);

        return dcustom != NULL;
    };

    void icm_brushtool_set_delegate(icm_brushtool w, icm_brushtool_delegate w_del) {
        icCanvasManager::BrushTool* d = (icCanvasManager::BrushTool*)w;
        icCanvasManager::BrushTool::Delegate* d_del = (icCanvasManager::BrushTool::Delegate*)w_del;

        d->set_delegate(d_del);
    };

    icm_brushtool_delegate icm_brushtool_get_delegate(icm_brushtool w) {
        icCanvasManager::BrushTool* d = (icCanvasManager::BrushTool*)w;

        return (void*)d->get_delegate();
    };
}
