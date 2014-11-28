#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

namespace icCanvasManager {
    class BrushToolDelegateCImpl : public BrushTool::Delegate, public RefCnt {
        icm_brushtool_delegate_captured_stroke_func captured_stroke_impl;
        void* captured_stroke_user_data;

    public:
        BrushToolDelegateCImpl() : captured_stroke_impl(NULL), captured_stroke_user_data(NULL) {}
        virtual ~BrushToolDelegateCImpl() {}

        virtual void captured_stroke(RefPtr<BrushStroke> stroke) {
            if (this->captured_stroke_impl) {
                BrushStroke* bs = stroke;
                this->captured_stroke_impl((void*)bs, this->captured_stroke_user_data);
            }
        }

        friend void ::icm_brushtool_delegate_set_custom_captured_stroke_func(icm_brushtool_delegate, icm_brushtool_delegate_captured_stroke_func, void*);
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

    icm_brushtool_delegate icm_brushtool_delegate_construct_custom() {
        auto* dcustom = new icCanvasManager::BrushToolDelegateCImpl();
        auto* d = static_cast<icCanvasManager::BrushTool::Delegate*>(dcustom);

        return (void*)d;
    };

    bool icm_brushtool_delegate_is_custom(icm_brushtool_delegate w) {
        icCanvasManager::BrushTool::Delegate* d = (icCanvasManager::BrushTool::Delegate*)w;
        auto* dcustom = dynamic_cast<icCanvasManager::BrushToolDelegateCImpl*>(d);

        return dcustom != NULL;
    };

    void icm_brushtool_delegate_set_custom_captured_stroke_func(icm_brushtool_delegate w, icm_brushtool_delegate_captured_stroke_func func, void* user_data) {
        icCanvasManager::BrushTool::Delegate* d = (icCanvasManager::BrushTool::Delegate*)w;
        auto* dcustom = dynamic_cast<icCanvasManager::BrushToolDelegateCImpl*>(d);

        if (dcustom) {
            dcustom->captured_stroke_impl = func;
            dcustom->captured_stroke_user_data = user_data;
        }
    };
}
