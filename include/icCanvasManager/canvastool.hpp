#ifndef __ICCANVASMANAGER_CANVASTOOL_HPP__
#define __ICCANVASMANAGER_CANVASTOOL_HPP__

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
        double _width, _height;   //In window-system coordinates.
        float _zoom;             //Number of canvas units per viewspace pixel.
        int _x_scroll, _y_scroll; //The top-left edge of the view in canvas coord
        int _x_center, _y_center; //The center of the screen, also canvas coords
        float _x_size, _y_size;   //Size of the view in canvas units.
        float _ui_scale;

    protected:
        void _window_size(double *width, double *height);
        void _window_zoom(double *zoom);

        /* Convert positions between window-space coordinates and canvas coordinates. */
        void _window_to_coordspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);
        void _coord_to_windowspace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);

        /* Convert vectors between ... */
        void _window_to_coordvector(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);
        void _coord_to_windowvector(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);

    public:
        CanvasTool();
        virtual ~CanvasTool();

        /* CanvasTools are reusable classes. Hitting this method causes the
         * instance to reset to initial state (e.g. forget about tracked events
         * in progress)
         */
        virtual void prepare_for_reuse() = 0;

        /* Configure the size of the tool's active area.
         *
         * The ui_scale parameter translates window-space units to device-space
         * units. The zoom parameter translates window-space units to canvas
         * units. Set_scroll_center allows for setting the tool's scroll center.
         *
         * The protected section includes utility functions for converting
         * between canvas and window space using these parameters.
         */
        virtual void set_size(const double width, const double height, const double ui_scale, const double zoom);
        virtual void set_scroll_center(const double x, const double y);

        /* Respond to mouse input on the canvas tool's active area.
         */
        virtual void mouse_down(const double x, const double y, const double deltaX, const double deltaY) = 0;
        virtual void mouse_drag(const double x, const double y, const double deltaX, const double deltaY) = 0;
        virtual void mouse_up(const double x, const double y, const double deltaX, const double deltaY) = 0;
    };
}

#endif
