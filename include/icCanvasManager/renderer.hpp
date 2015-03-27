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
         * At this stage the renderer is not required to place the tile within
         * a Cairo image surface.
         */
        virtual void enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) = 0;
        
        /* Given a brushstroke, draw it onto the surface at the specified
         * position and zoom level.
         */
        virtual void draw_stroke(RefPtr<BrushStroke> br) = 0;

        /* After rendering has finished, it may be copied to a Cairo image
         * surface of the client's choosing. This may happen in two ways:
         *
         *    The client may provide a compatible cairo_surface_t by
         *    implementing the retrieve_image_surface method and returning
         *    a non-NULL pointer.
         *
         *    The client may copy the current surface into a Cairo surface
         */
        virtual cairo_surface_t* retrieve_image_surface();
        virtual void transfer_to_image_surface(cairo_surface_t* surf) = 0;
    };
}

#endif
