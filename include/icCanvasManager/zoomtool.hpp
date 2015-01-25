#ifndef __ICCANVASMANAGER_ZOOMTOOL_HPP__
#define __ICCANVASMANAGER_ZOOMTOOL_HPP__

#include <icCanvasManager.hpp>

namespace icCanvasManager {
    /* Delegate protocol class used to inform tool users of zoom behaviors.
     *
     * If the delegate subclass does not also inherit from RefCnt, then you
     * must ensure that the delegate is alive for as long as the Tool uses
     * it.
     */
    class ZoomToolDelegate {
    public:
        virtual ~ZoomToolDelegate();

        /* Called when the Tool captures a new scroll position and zoom factor.
         */
        virtual void changed_scroll_and_zoom(const double x, const double y, const double zoom) = 0;
    };

    /*
     * A CanvasTool that allows the user to zoom the canvas.
     */
    class ZoomTool : public CanvasTool, public Delegator<ZoomTool, ZoomToolDelegate> {
    public:
        typedef ZoomToolDelegate Delegate;
    private:
        bool _is_tracking_click, _is_tracking_zoom;
        int _initial_scroll_x, _initial_scroll_y, _target_scroll_x, _target_scroll_y;
        double _initial_x, _initial_y, _breaking_x, _breaking_y, _initial_zoom;
    public:
        ZoomTool();
        virtual ~ZoomTool();

        //CanvasTool impl
        void prepare_for_reuse();
        void set_size(const double width, const double height, const double ui_scale, const double zoom);
        void mouse_down(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_drag(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_up(const double x, const double y, const double deltaX, const double deltaY);
    };
}

#endif
