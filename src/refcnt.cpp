#include <icCanvasManager.hpp>

icCanvasManager::RefCnt::RefCnt() : references(0) {}
icCanvasManager::RefCnt::~RefCnt() {}

int icCanvasManager::RefCnt::ref() {
    return ++this->references;
};

int icCanvasManager::RefCnt::deref() {
    return --this->references;
};
