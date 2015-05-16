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

            /* Convenience method for image surfaces. */
            void enter_image_surface(const int32_t x, const int32_t y, const int32_t zoom, cairo_surface_t* xrsurf);

            /* Given a brushstroke, draw it onto the surface at the specified
             * position and zoom level.
             */
            virtual void draw_stroke(RefPtr<BrushStroke> br) override;

            virtual DisplaySuiteTILE copy_to_tile() override;
        };
    }
}

#endif
