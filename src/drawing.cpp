#include <icCanvasManager.hpp>

icCanvasManager::Drawing::Drawing() {
    this->strokes.emplace_back();
    auto aStrokeItr = this->strokes.begin();
    
    aStrokeItr->pen_begin(-65535, 32768);
    aStrokeItr->pen_to(-32768, -65535, -8192, 16555, 65535, -32768);
};
icCanvasManager::Drawing::~Drawing() {};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::begin() {
    this->strokes.begin();
};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::end() {
    this->strokes.end();
};