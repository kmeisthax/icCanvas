#ifndef __ICCANVASMANAGER_CANVASVIEW_HPP__
#define __ICCANVASMANAGER_CANVASVIEW_HPP__

#include <icCanvasManager.hpp>

namespace icCanvasManager {
    /*
     * Hotswappable bundle of reusable mouse behaviors that constitutes a tool.
     * A brush tool, for example, would take the mouse input and build strokes
     * from that.
     *
     * CanvasTool is itself an abstract interface to be implemented by other
     * classes which translate events into operations.
     */
    class CanvasTool : public RefCnt {
    public:
        CanvasTool();
        virtual ~CanvasTool();

        /* CanvasTools are reusable classes. Hitting this method causes the
         * instance to reset to initial state (e.g. forget about tracked events
         * in progress)
         */
        void prepare_for_reuse();

        /* Configure the size of the tool's active area.
         *
         * The ui_scale parameter translates window-space units to device-space
         * units. The zoom parameter translates window-space units to canvas
         * units.
         */
        void set_size(const double width, const double height, const double ui_scale, const double zoom);

        /* Respond to mouse input on the canvas tool's active area.
         */
        void mouse_down(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_drag(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_up(const double x, const double y, const double deltaX, const double deltaY);
    }
}
