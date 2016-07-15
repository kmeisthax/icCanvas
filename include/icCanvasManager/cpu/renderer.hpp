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
        private:
            void intersect_circle_arcs(int32_t c1Radius, int32_t c2x, int32_t c2y, int32_t c2Radius, float *out_iAngleFirst, float *out_iAngleSecond);
            void quadratic_roots(double a, double b, double c, double *out_first, double *out_second);
            bool modular_contained(float low, float high, float test);
            void clip_arc_range(float arc1Start, float arc1End, float arc2Start, float arc2End, float *out_intStart, float *out_intEnd);
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
