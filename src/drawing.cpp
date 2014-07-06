#include <icCanvasManager.hpp>

icCanvasManager::Drawing::Drawing() {
    this->strokes.emplace_back();
    auto aStrokeItr = this->strokes.begin();
    
    aStrokeItr->pen_begin(-65535, 32768);
    aStrokeItr->pen_to(-32768, -65535, -8192, 16555, 65535, -32768);
    aStrokeItr->pen_extend();
    aStrokeItr->pen_to(70000, 20000, 80000, 40000, 85000, 45000);
};
icCanvasManager::Drawing::~Drawing() {};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::begin() {
    this->strokes.begin();
};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::end() {
    this->strokes.end();
};

icCanvasManager::BrushStroke& icCanvasManager::Drawing::stroke_at_time(int time) {
    return this->strokes.at(time);
};

int icCanvasManager::Drawing::strokes_count() {
    return this->strokes.count();
};
