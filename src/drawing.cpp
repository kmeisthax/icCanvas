#include <icCanvasManager.hpp>

icCanvasManager::Drawing::Drawing() {
    this->strokes.emplace_back();
    auto aStrokeItr = this->strokes.begin();
    
    aStrokeItr->pen_begin(32, 16);
    aStrokeItr->pen_to(32, 16, 16, 32, 16, 32);
};
icCanvasManager::Drawing::~Drawing() {};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::begin() {
    this->strokes.begin();
};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::end() {
    this->strokes.end();
};