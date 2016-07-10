#include <icCanvasManager.hpp>

icCanvasManager::CPU::DisplaySuite::DisplaySuite() {};
icCanvasManager::CPU::DisplaySuite::~DisplaySuite() {};

/* DisplaySuite impls */
void icCanvasManager::CPU::DisplaySuite::report_concurrency_level(icCanvasManager::DisplaySuite::ConcurrencyLevel *out_renderer_lvl, icCanvasManager::DisplaySuite::ConcurrencyLevel *out_presenter_lvl) {
    if (out_renderer_lvl) *out_renderer_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_MULTIPLE_INSTANCES;
    if (out_presenter_lvl) *out_presenter_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_MAIN_THREAD_ONLY;
};

icCanvasManager::Renderer* icCanvasManager::CPU::DisplaySuite::create_renderer() {
    //TODO: Define CPU::Renderer, return it here
    return null;
};

void icCanvasManager::CPU::DisplaySuite::free_tile(icCanvasManager::DisplaySuiteTILE tile) {
    delete[] reinterpret_cast<icCanvasManager::TileCache::TileData>(tile);
};

//Direct transfer paths are meaningless since import/export
//are no-ops for now.
bool icCanvasManager::CPU::DisplaySuite::can_direct_transfer(icCanvasManager::DisplaySuite *other) {
    return false;
};

icCanvasManager::DisplaySuiteTILE icCanvasManager::CPU::DisplaySuite::direct_transfer(icCanvasManager::DisplaySuite* other, icCanvasManager::DisplaySuiteTILE tile, bool copy_bit) {
    return 0;
};

icCanvasManager::TileCache::TileData icCanvasManager::CPU::DisplaySuite::export_tile(icCanvasManager::DisplaySuiteTILE tile) {
    return reinterpret_cast<icCanvasManager::TileCache::TileData>(tile);
};

icCanvasManager::DisplaySuiteTILE icCanvasManager::CPU::DisplaySuite::import_tile(icCanvasManager::TileCache::TileData tile_dat) {
    //TODO: Implement tile import
    return 0;
};
