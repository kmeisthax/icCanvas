#ifndef __ICCANVASMANAGER_RENDERER_HPP__
#define __ICCANVASMANAGER_RENDERER_HPP__

#include "../icCanvasManager.hpp"

#include <cairo.h>
#include <cstdint>

namespace icCanvasManager {
    /* Class which implements icCanvas drawing methods.
     */
    class Renderer : public virtual RefCnt {
    protected:
        /* Convert stroke coordinates to tile space. */
        void coord_to_tilespace(const int32_t x, const int32_t y, int32_t* out_tx, int32_t* out_ty);

        int32_t x, y, zoom;             //Canvas parameters
        int32_t tw, th;                 //Surface parameters
        float xscale, yscale;           //Derived caluations
        int32_t xmin, xmax, ymin, ymax;
    public:
        Renderer();
        virtual ~Renderer();

        /* Create a new tile surface of the renderer's own choosing.
         * 
         * This call also implicitly clears the rendering surface, so that
         * previously drawn strokes do not appear below the new strokes.
         */
        virtual void enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) = 0;
        
        /* Given a brushstroke, draw it onto the surface at the specified
         * position and zoom level.
         */
        virtual void draw_stroke(RefPtr<BrushStroke> br) = 0;

        /* After rendering has finished, it may be copied to a TILE, the opaque
         * type of the preferred representation of the Renderer's DisplaySuite.
         *
         */
        virtual DisplaySuiteTILE copy_to_tile() = 0;
    };
}

#endif
