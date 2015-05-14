#include <icCanvasManager.hpp>

icCanvasManager::Cairo::DisplaySuite::DisplaySuite() {};
icCanvasManager::Cairo::DisplaySuite::~DisplaySuite() {};

void icCanvasManager::Cairo::DisplaySuite::report_concurrency_level(icCanvasManager::DisplaySuite::ConcurrencyLevel *out_renderer_lvl, icCanvasManager::DisplaySuite::ConcurrencyLevel *out_presenter_lvl) {
    if (out_renderer_lvl) *out_renderer_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_MAIN_THREAD_ONLY;
    if (out_presenter_lvl) *out_presenter_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_MAIN_THREAD_ONLY;
};

icCanvasManager::Renderer* icCanvasManager::Cairo::DisplaySuite::create_renderer() {
    return new icCanvasManager::Cairo::Renderer();
};

void icCanvasManager::Cairo::DisplaySuite::free_tile(icCanvasManager::DisplaySuite::TILE tile) {
    cairo_surface_destroy((cairo_surface_t*)tile);
};

//No direct transfers are currently supported.
bool icCanvasManager::Cairo::DisplaySuite::can_direct_transfer(icCanvasManager::DisplaySuite *other) {
    return false;
};

icCanvasManager::DisplaySuite::TILE icCanvasManager::Cairo::DisplaySuite::direct_transfer(icCanvasManager::DisplaySuite* other, icCanvasManager::DisplaySuite::TILE tile, bool copy_bit) {
    return 0;
};

//TODO: Support generic transfers
icCanvasManager::TileCache::TileData* icCanvasManager::Cairo::DisplaySuite::export_tile(icCanvasManager::DisplaySuite::TILE tile) {
    return NULL;
};

//TODO: Support generic transfers
icCanvasManager::DisplaySuite::TILE icCanvasManager::Cairo::DisplaySuite::import_tile(icCanvasManager::TileCache::TileData *tile_dat) {
    return 0;
};
