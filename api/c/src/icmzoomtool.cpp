#include <icCanvasManager.hpp>

#include <icCanvasManagerC.h>

namespace icCanvasManager {
    class ZoomToolDelegateCImpl : public ZoomTool::Delegate, public RefCnt {
        icm_zoomtool_delegate_hooks hooks;

    public:
        ZoomToolDelegateCImpl(icm_zoomtool_delegate_hooks* hooks) : hooks(*hooks), RefCnt() {}
        virtual ~ZoomToolDelegateCImpl() {
            if (this->hooks.changed_scroll_and_zoom_target_destroy_notify) {
                this->hooks.changed_scroll_and_zoom_target_destroy_notify(this->hooks.changed_scroll_and_zoom_context);
            }
        }

        virtual void changed_scroll_and_zoom(const double x, const double y, const double zoom) {
            if (this->hooks.changed_scroll_and_zoom) {
                this->hooks.changed_scroll_and_zoom(x, y, zoom, this->hooks.changed_scroll_and_zoom_context);
            }
        }
    };
}

extern "C" {
    icm_zoomtool icm_zoomtool_construct() {
        icCanvasManager::ZoomTool* d = new icCanvasManager::ZoomTool();
        d->ref();

        return (icm_zoomtool)d;
    };

    icm_zoomtool icm_zoomtool_reference(icm_zoomtool w) {
        icCanvasManager::ZoomTool* d = (icCanvasManager::ZoomTool*)w;
        d->ref();

        return w;
    };

    int icm_zoomtool_dereference(icm_zoomtool w) {
        icCanvasManager::ZoomTool* d = (icCanvasManager::ZoomTool*)w;
        int refcount = d->deref();

        if (refcount <= 0) {
            delete d;
        }

        return refcount;
    };

    icm_zoomtool icm_zoomtool_downcast(icm_canvastool up_obj) {
        icCanvasManager::CanvasTool* up = (icCanvasManager::CanvasTool*)up_obj;
        icCanvasManager::ZoomTool* down = dynamic_cast<icCanvasManager::ZoomTool*>(up);

        return (void*)down;
    };

    icm_canvastool icm_zoomtool_upcast(icm_zoomtool down_obj) {
        icCanvasManager::ZoomTool* down = (icCanvasManager::ZoomTool*)down_obj;
        icCanvasManager::CanvasTool* up = static_cast<icCanvasManager::CanvasTool*>(down);

        return (void*)up;
    };

    icm_zoomtool_delegate icm_zoomtool_delegate_reference(icm_zoomtool_delegate w) {
        icCanvasManager::ZoomTool::Delegate* d = (icCanvasManager::ZoomTool::Delegate*)w;
        icCanvasManager::RefCnt* d_refable = dynamic_cast<icCanvasManager::RefCnt*>(d_refable);

        if (d_refable) {
            d_refable->ref();
        }

        return w;
    };

    int icm_zoomtool_delegate_dereference(icm_zoomtool_delegate w) {
        icCanvasManager::ZoomTool::Delegate* d = (icCanvasManager::ZoomTool::Delegate*)w;
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

    icm_zoomtool_delegate icm_zoomtool_delegate_construct_custom(icm_zoomtool_delegate_hooks* hooks) {
        icCanvasManager::ZoomToolDelegateCImpl* dcustom = new icCanvasManager::ZoomToolDelegateCImpl(hooks);
        icCanvasManager::ZoomTool::Delegate* d = dcustom;
        dcustom->ref();

        return (void*)d;
    };

    bool icm_zoomtool_delegate_is_custom(icm_zoomtool_delegate w) {
        icCanvasManager::ZoomTool::Delegate* d = (icCanvasManager::ZoomTool::Delegate*)w;
        auto* dcustom = dynamic_cast<icCanvasManager::ZoomToolDelegateCImpl*>(d);

        return dcustom != NULL;
    };

    void icm_zoomtool_set_delegate(icm_zoomtool w, icm_zoomtool_delegate w_del) {
        icCanvasManager::ZoomTool* d = (icCanvasManager::ZoomTool*)w;
        icCanvasManager::ZoomTool::Delegate* d_del = (icCanvasManager::ZoomTool::Delegate*)w_del;

        d->set_delegate(d_del);
    };

    icm_zoomtool_delegate icm_zoomtool_get_delegate(icm_zoomtool w) {
        icCanvasManager::ZoomTool* d = (icCanvasManager::ZoomTool*)w;

        return (void*)d->get_delegate();
    };

    //This code does nothing in particular that we care about, it's just there to get Vala to generate correct code
    void icm_zoomtool_delegate_hooks_destroy(icm_zoomtool_delegate_hooks* blargh) {

    };
}
