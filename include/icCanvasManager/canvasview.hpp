#ifndef __ICCANVASMANAGER_CANVASVIEW_HPP__
#define __ICCANVASMANAGER_CANVASVIEW_HPP__

#include <icCanvasManager.hpp>

#include <cairo.h>

namespace icCanvasManager {
    /*
     * Library-side, platform agnostic holder of Canvas view behaviors.
     */
    class CanvasView : public RefCnt {
        RefPtr<Renderer> renderer;
        RefPtr<Drawing> drawing;
        double width, height;
    public:
        CanvasView();
        ~CanvasView();

        /* Attach a drawing to the canvas view. */
        void attach_drawing(RefPtr<Drawing> drawing);

        /* Respond to a drawing request from the native window system or UI
         * toolkit.
         */
        void draw(cairo_t *ctxt, cairo_rectangle_t dirtyArea);

        /* Respond to a resize from the native window system. */
        void set_size(double width, double height);
    };
}

#endif
