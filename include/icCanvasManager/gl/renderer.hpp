#ifndef __ICCANVASMANAGER_GL_RENDERER_HPP__
#define __ICCANVASMANAGER_GL_RENDERER_HPP__

#include "../../icCanvasManager.hpp"

#include <cairo.h>
#include <PlatformGL.h>
#include <cstdint>

namespace icCanvasManager {
    namespace GL {
        /* Class which renders certain drawing operations via OpenGL.
         *
         * Requires a fully-specified ContextManager which is provided by
         * frontend code.
         */
        class Renderer : public virtual RefCnt, public virtual icCanvasManager::Renderer {
            GLuint vShader, fShader, dProgram, renderTarget, renderColorTexture, raymarchGeom, raymarchVertex;

            RefPtr<Extensions> ex;
            RefPtr<ContextManager> m;

            float curve_arc_length(int polynomID, icCanvasManager::BrushStroke::__Spline::derivative_type &dt);
        protected:
        public:
            Renderer(RefPtr<ContextManager> m, ContextManager::CONTEXT target, ContextManager::DRAWABLE window);
            virtual ~Renderer();

            virtual void enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) override;
            virtual void draw_stroke(RefPtr<BrushStroke> br) override;
            virtual DisplaySuiteTILE copy_to_tile() override;
        };
    }
}

#endif
