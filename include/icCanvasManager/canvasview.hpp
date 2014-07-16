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
        RefPtr<SplineFitter> fitter;
        RefPtr<Drawing> drawing;

        double width, height;   //In window-system coordinates.
        float zoom;             //Same as the Renderer zoom levels.
        int x_scroll, y_scroll; //In canvas coordinates.
        float x_scale, y_scale;

        //During spline fitting only.
        RefPtr<BrushStroke> built_stroke;

        //Convert window-space coordinates to canvas coordinates.
        windowToCoordspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty)
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

        /* Respond to mouse input. */
        void mouse_down(int x, int y, int deltaX, int deltaY);
        void mouse_drag(int x, int y, int deltaY, int deltaY);
        void mouse_up(int x, int y, int deltaX, int deltaY);
    };
}

#endif
