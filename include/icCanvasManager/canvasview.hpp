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
        int x_scroll, y_scroll; //The top-left edge of the view in canvas coord
        int x_center, y_center; //The center of the screen, also canvas coords
        float x_scale, y_scale;
        float ui_scale;

        //During spline fitting only.
        RefPtr<BrushStroke> built_stroke;

        //Convert window-space coordinates to canvas coordinates.
        void windowToCoordspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);
    public:
        CanvasView();
        ~CanvasView();

        /* Attach a drawing to the canvas view. */
        void attach_drawing(RefPtr<Drawing> drawing);

        /* Respond to a drawing request from the native window system or UI
         * toolkit.
         *
         * The provided cairo context must provide a coordinate system scaled
         * such that one pixel in the context represents as many physical
         * display pixels as is specified in set_size. Some window systems may
         * perform this for you, others do not.
         */
        void draw(cairo_t *ctxt, cairo_rectangle_t dirtyArea);

        /* Respond to a resize from the native window system.
         *
         * The ui_scale parameter indicates how many physical display pixels
         * are present per window-space pixels.
         */
        void set_size(double width, double height, double ui_scale);

        /* Respond to mouse input. */
        void mouse_down(int x, int y, int deltaX, int deltaY);
        void mouse_drag(int x, int y, int deltaX, int deltaY);
        void mouse_up(int x, int y, int deltaX, int deltaY);
    };
}

#endif
