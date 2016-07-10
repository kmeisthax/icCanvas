#ifndef __ICCANVASMANAGER_CPU_RENDERER_HPP__
#define __ICCANVASMANAGER_CPU_RENDERER_HPP__

#include "../../icCanvasManager.hpp"

#include <cairo.h>
#include <PlatformGL.h>
#include <cstdint>

namespace icCanvasManager {
    namespace CPU {
        /* Class which renders certain drawing operations on CPU. Intended as
         * a fallback for non-GPU deployment; can be multithreaded.
         */
        class Renderer : public virtual RefCnt, public virtual icCanvasManager::Renderer {
        protected:
        public:
            Renderer();
            virtual ~Renderer();

            virtual void enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) override;
            virtual void draw_stroke(RefPtr<BrushStroke> br) override;
            virtual DisplaySuiteTILE copy_to_tile() override;
        };
    }
}

#endif
