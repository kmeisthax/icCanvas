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
        float zoom;             //Number of canvas units per viewspace pixel.
        int x_scroll, y_scroll; //The top-left edge of the view in canvas coord
        int x_center, y_center; //The center of the screen, also canvas coords
        float x_size, y_size;   //Size of the view in canvas units.
        float ui_scale;

        //During spline fitting only.
        RefPtr<BrushStroke> built_stroke;

        //Convert window-space coordinates to canvas coordinates and back.
        void windowToCoordspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);
        void coordToWindowspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);

        //Request all tiles within a particular rectangle.
        void request_tiles(cairo_rectangle_t* rect);

        //Draw tiles within a particular rectangle.
        void draw_tiles(cairo_t* ctxt, cairo_rectangle_t* rect);
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
         *
         * The rectList passed in is used to determine what regions of the
         * widget to draw. It must be valid. draw does not destroy rectList.
         */
        void draw(cairo_t *ctxt, cairo_rectangle_list_t *rectList);

        /* Respond to a resize from the native window system.
         *
         * The ui_scale parameter indicates how many physical display pixels
         * are present per window-space pixels.
         */
        void set_size(const double width, const double height, const double ui_scale);

        /* Configure the internal widget size to be the whole canvas size.
         *
         * This is useful for window systems that handle their own scrolling,
         * assuming that they can represent a widget 2^32 pixels big.
         */
        void set_size(const double ui_scale);

        /* Get the currently configured size.
         */
        void get_size(double *out_width, double *out_height, double *out_ui_scale);

        /* Set the current center point on the canvas to render from.
         *
         * If you are using the UI toolkit's native scrolling, set this to zero
         * and never look back.
         */
        void set_scroll_center(const double x, const double y);

        /* Set the zoom factor of the view.
         */
        void set_zoom(const double vpixel_size);

        /* Respond to mouse input. */
        void mouse_down(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_drag(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_up(const double x, const double y, const double deltaX, const double deltaY);
    };
}

#endif
