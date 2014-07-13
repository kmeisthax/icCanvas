#ifndef __ICCANVASMANAGER_DRAWING_HPP__
#define __ICCANVASMANAGER_DRAWING_HPP__

#include "../icCanvasManager.hpp"

#include <vector>

namespace icCanvasManager {
    //Class which stores all context relating to a drawing.
    class Drawing : public RefCnt {
        //TODO: Layer model
        std::vector<RefPtr<BrushStroke>> strokes;
    public:
        typedef std::vector<RefPtr<BrushStroke>>::iterator stroke_iterator;
        
        Drawing();
        virtual ~Drawing();
        
        stroke_iterator begin();
        stroke_iterator end();
        RefPtr<BrushStroke> stroke_at_time(int time);
        int strokes_count();

        void append_stroke(RefPtr<BrushStroke> stroke);
    };
}

#endif
