#ifndef __ICCANVASMANAGER_CAIRO_RENDERER_HPP__
#define __ICCANVASMANAGER_CAIRO_RENDERER_HPP__

#include "../../icCanvasManager.hpp"

#include <cairo.h>
#include <cstdint>

namespace icCanvasManager {
    namespace Cairo {
        /* Legacy Cairo renderer. Renders brush strokes as tightly-packed series of
         * transparent circles.
         */
        class Renderer : public virtual RefCnt, public virtual icCanvasManager::Renderer {
            cairo_surface_t* xrsurf;        //Cairo surface to draw on
            cairo_t*         xrctxt;        //Context for current surface

            /* Draw the current brush at a particular point. */
            void apply_brush(RefPtr<BrushStroke> br, const BrushStroke::__ControlPoint &cp);

            class _DifferentialCurveFunctor;
            float curve_arc_length(int polynomID, BrushStroke::__Spline::derivative_type &dt);
        public:
            Renderer();
            virtual ~Renderer();

            virtual void enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) override;

            /* Specify the current drawing surface, location, and zoom level.
             *
             * The cairo surface pointer given to the renderer does not transfer
             * memory ownership, but must point to valid memory for the entire time
             * that you draw with this renderer.
             *
             * A fresh context will be created for your surface. For drawing onto
             * already existing contexts, see enterContext.
             */
            void enter_surface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf, const int height, const int width);

            /* Convenience method for image surfaces. */
            void enter_image_surface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf);

            /* Convenience method for drawing directly to GUI widgets.
             */
            void enter_context(const int32_t x, const int32_t y, const int32_t zoom, cairo_t* xrctxt, const int height, const int width);

            /* Given a brushstroke, draw it onto the surface at the specified
             * position and zoom level.
             */
            virtual void draw_stroke(RefPtr<BrushStroke> br) override;

            virtual cairo_surface_t* retrieve_image_surface() override;
            virtual void transfer_to_image_surface(cairo_surface_t* surf) override;
        };
    }
}

#endif
