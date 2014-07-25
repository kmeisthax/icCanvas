#include <icCanvasManager.hpp>

icCanvasManager::Drawing::Drawing() {
    this->_cache = new icCanvasManager::TileCache();
    this->_scheduler = new icCanvasManager::RenderScheduler();
};
icCanvasManager::Drawing::~Drawing() {};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::begin() {
    return this->_strokes.begin();
};

icCanvasManager::Drawing::stroke_iterator icCanvasManager::Drawing::end() {
    return this->_strokes.end();
};

icCanvasManager::RefPtr<icCanvasManager::BrushStroke> icCanvasManager::Drawing::stroke_at_time(int time) {
    return this->_strokes.at(time);
};

int icCanvasManager::Drawing::strokes_count() {
    return this->_strokes.size();
};

void icCanvasManager::Drawing::append_stroke(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> stroke) {
    this->_strokes.emplace_back(stroke);
};

icCanvasManager::RefPtr<icCanvasManager::TileCache> icCanvasManager::Drawing::get_tilecache() {
    return this->_cache;
};

icCanvasManager::RefPtr<icCanvasManager::RenderScheduler> icCanvasManager::Drawing::get_scheduler() {
    return this->_scheduler;
};
