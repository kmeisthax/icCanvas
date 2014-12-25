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

        double width, height;   //In window-system coordinates.
        float zoom;             //Number of canvas units per viewspace pixel.
        int x_scroll, y_scroll; //The top-left edge of the view in canvas coord
        int x_center, y_center; //The center of the screen, also canvas coords
        float x_size, y_size;   //Size of the view in canvas units.
        float ui_scale;

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
         *
         * The maximum_size function returns the maximum extent of the view.
         * You may size the view larger, however; space outside the canvas will
         * be filled with gray emptiness.
         */
        void get_size(double *out_width, double *out_height, double *out_ui_scale);
        void get_maximum_size(double *out_maxwidth, double *out_maxheight);

        /* Get the extents of magnification for the currently configured canvas.
         *
         * At scales smaller than minscale, the currently configured size of
         * the widget will be larger than the resulting canvas. At scales
         * larger than maxscale, one window-space pixel will exceed the size of
         * a canvas unit.
         */
        void get_scale_extents(double *out_minscale, double *out_maxscale);

        /* Set the current center point on the canvas to render from.
         *
         * Some UI toolkits handle scrolling by allowing the widget to size
         * itself as needed and using the clip rectangle and coordinate
         * transforms to place the view coordinate space in the correct area.
         * In that case, set this to zero and never look back.
         */
        void set_scroll_center(const double x, const double y);

        /* Set the zoom factor of the view.
         *
         * Some UI toolkits handle zooming by scaling the coordinate transform
         * of the provided drawing context up or down, e.g. conflating it with
         * the physical pixel scale factor. In that case, do not call set_zoom.
         */
        double get_zoom();
        void set_zoom(const double vpixel_size);
    };
}

#endif
