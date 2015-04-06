#ifndef __ICCANVASMANAGER_GL_RENDERER_HPP__
#define __ICCANVASMANAGER_GL_RENDERER_HPP__

#include "../../icCanvasManager.hpp"

#include <cairo.h>
#include <GL/gl.h>
#include <cstdint>

namespace icCanvasManager {
    namespace GL {
        /* Class which renders certain drawing operations via OpenGL.
         *
         * Requires a fully-specified ContextManager which is provided by
         * frontend code.
         */
        class Renderer : public virtual RefCnt, public virtual icCanvasManager::Renderer {
            GLuint vShader, fShader;
        protected:
        public:
            Renderer(RefPtr<ContextManager> m, ContextManager::CONTEXT target, ContextManager::DRAWABLE window);
            virtual ~Renderer();

            /* Create a new tile surface of the renderer's own choosing.
             *
             * At this stage the renderer is not required to place the tile within
             * a Cairo image surface.
             */
            virtual void enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) override;

            /* Given a brushstroke, draw it onto the surface at the specified
             * position and zoom level.
             */
            virtual void draw_stroke(RefPtr<BrushStroke> br) override;

            /* After rendering has finished, it may be copied to a Cairo image
             * surface of the client's choosing. This may happen in two ways:
             *
             *    The client may provide a compatible cairo_surface_t by
             *    implementing the retrieve_image_surface method and returning
             *    a non-NULL pointer.
             *
             *    The client may copy the current surface into a Cairo surface
             */
            virtual cairo_surface_t* retrieve_image_surface() override;
            virtual void transfer_to_image_surface(cairo_surface_t* surf) override;
        };
    }
}

#endif
