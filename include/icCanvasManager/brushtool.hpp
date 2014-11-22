#ifndef __ICCANVASMANAGER_BRUSHTOOL_HPP__
#define __ICCANVASMANAGER_BRUSHTOOL_HPP__

#include <icCanvasManager.hpp>

namespace icCanvasManager {
    /*
     * A CanvasTool that records brush strokes.
     */
    class BrushTool : public CanvasTool {
    public:
        /* Delegate protocol class used to inform tool users of new strokes.
         *
         * If the delegate subclass does not also inherit from RefCnt, then you
         * must ensure that the delegate is alive for as long as the Tool uses
         * it.
         */
        class Delegate {
        public:
            virtual ~Delegate();

            /* Called when the Tool captures a brushstroke.
             */
            virtual void captured_stroke(RefPtr<BrushStroke> stroke) = 0;
        };

    private:
        Delegate* _delegate;
        RefPtr<RefCnt> _delegate_lifetime;

        int _error_threshold;

        RefPtr<SplineFitter> _fitter;
        RefPtr<BrushStroke> _built_stroke;
        bool _is_fitting;

    public:
        BrushTool();
        virtual ~BrushTool();

        //CanvasTool impl
        void prepare_for_reuse();
        void set_size(const double width, const double height, const double ui_scale, const double zoom);
        void mouse_down(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_drag(const double x, const double y, const double deltaX, const double deltaY);
        void mouse_up(const double x, const double y, const double deltaX, const double deltaY);

        /* Set/get the delegate for this tool. */
        void set_delegate(Delegate* del);
        Delegate* get_delegate();
    };
}

#endif
