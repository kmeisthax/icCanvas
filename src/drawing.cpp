#include <icCanvasManager.hpp>

icCanvasManager::Drawing::Drawing() {};
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

void icCanvasManager::Drawing::append_stroke(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> stroke) {
    this->strokes.emplace_back(stroke);
};
