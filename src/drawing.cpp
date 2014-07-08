#include <icCanvasManager.hpp>

icCanvasManager::Drawing::Drawing() {
    auto aStroke = new icCanvasManager::BrushStroke();
    this->strokes.emplace_back(aStroke);
    
    aStroke->pen_begin(-65535, 32768);
    aStroke->pen_to(-32768, -65535, 32768, -16384, 65535, -32768);
    aStroke->pen_extend();
    aStroke->pen_to(98303, -49152, 80000, 40000, 85000, 45000);
};
icCanvasManager::Drawing::~Drawing() {};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::begin() {
    return this->strokes.begin();
};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::end() {
    return this->strokes.end();
};

icCanvasManager::RefPtr<icCanvasManager::BrushStroke> icCanvasManager::Drawing::stroke_at_time(int time) {
    return this->strokes.at(time);
};

int icCanvasManager::Drawing::strokes_count() {
    return this->strokes.size();
};
