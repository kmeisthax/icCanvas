#ifndef __ICCANVASMANAGER_RENDERER_HPP__
#define __ICCANVASMANAGER_RENDERER_HPP__

#include "../icCanvasManager.hpp"

#include <cairo.h>
#include <cstdint>

namespace icCanvasManager {
    /* Class which implements icCanvas drawing methods.
     */
    class Renderer : public RefCnt {
        int32_t x, y, zoom;             //Canvas parameters
        int32_t tw, th;                 //Surface parameters
        float xscale, yscale;           //Derived caluations
        int32_t xmin, xmax, ymin, ymax;

        cairo_surface_t* xrsurf;        //Cairo surface to draw on
        cairo_t*         xrctxt;        //Context for current surface
        
        /* Convert stroke coordinates to tile space. */
        void coordToTilespace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);

        /* Draw the current brush at a particular point. */
        void applyBrush(const BrushStroke::__ControlPoint &cp);
        
        class _DifferentialCurveFunctor;
        float curve_arc_length(int polynomID, BrushStroke::__Spline::derivative_type &dt);
    public:
        Renderer();
        virtual ~Renderer();

        /* Specify the current drawing surface, location, and zoom level.
         * 
         * The cairo surface pointer given to the renderer does not transfer
         * memory ownership, but must point to valid memory for the entire time
         * that you draw with this renderer.
         * 
         * A fresh context will be created for your surface. For drawing onto
         * already existing contexts, see enterContext.
         */
        void enterSurface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf, const int height, const int width);

        /* Convenience method for image surfaces. */
        void enterImageSurface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf);
        
        /* Convenience method for drawing directly to GUI widgets.
         */
        void enterContext(const int32_t x, const int32_t y, const int32_t zoom, cairo_t* xrctxt, const int height, const int width);
        
        /* Given a brushstroke, draw it onto the surface at the specified
         * position and zoom level.
         */
        void drawStroke(RefPtr<BrushStroke> br);
    };
}

#endif
