#include <icCanvasManager.hpp>

icCanvasManager::Drawing::Drawing() {
    this->strokes.emplace_back();
    auto aStrokeItr = this->strokes.begin();
    
    aStrokeItr->pen_begin(-65535, 32768);
    aStrokeItr->pen_to(-32768, -65535, 32768, -16384, 65535, -32768);
    aStrokeItr->pen_extend();
    aStrokeItr->pen_to(98303, -49152, 80000, 40000, 85000, 45000);
};
icCanvasManager::Drawing::~Drawing() {};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::begin() {
    this->strokes.begin();
};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::end() {
    this->strokes.end();
};