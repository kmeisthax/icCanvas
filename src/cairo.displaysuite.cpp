#include <icCanvasManager.hpp>

#include <iostream>

icCanvasManager::Cairo::DisplaySuite::DisplaySuite() {};
icCanvasManager::Cairo::DisplaySuite::~DisplaySuite() {};

void icCanvasManager::Cairo::DisplaySuite::report_concurrency_level(icCanvasManager::DisplaySuite::ConcurrencyLevel *out_renderer_lvl, icCanvasManager::DisplaySuite::ConcurrencyLevel *out_presenter_lvl) {
    if (out_renderer_lvl) *out_renderer_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_MAIN_THREAD_ONLY;
    if (out_presenter_lvl) *out_presenter_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_MAIN_THREAD_ONLY;
};

icCanvasManager::Renderer* icCanvasManager::Cairo::DisplaySuite::create_renderer() {
    return new icCanvasManager::Cairo::Renderer();
};

void icCanvasManager::Cairo::DisplaySuite::free_tile(icCanvasManager::DisplaySuiteTILE tile) {
    cairo_surface_destroy((cairo_surface_t*)tile);
};

//No direct transfers are currently supported.
bool icCanvasManager::Cairo::DisplaySuite::can_direct_transfer(icCanvasManager::DisplaySuite *other) {
    return false;
};

icCanvasManager::DisplaySuiteTILE icCanvasManager::Cairo::DisplaySuite::direct_transfer(icCanvasManager::DisplaySuite* other, icCanvasManager::DisplaySuiteTILE tile, bool copy_bit) {
    return 0;
};

//TODO: Support generic transfers
icCanvasManager::TileCache::TileData icCanvasManager::Cairo::DisplaySuite::export_tile(icCanvasManager::DisplaySuiteTILE tile) {
    return NULL;
};

static void freed_imported_tile(void* data) {
    free(data);
};

icCanvasManager::DisplaySuiteTILE icCanvasManager::Cairo::DisplaySuite::import_tile(icCanvasManager::TileCache::TileData tile_dat) {
    std::cout << "CAIRO: Importing tile...";

    auto cairo_stride = cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, icCanvasManager::TileCache::TILE_SIZE);
    unsigned char* data = (unsigned char*)malloc(cairo_stride * icCanvasManager::TileCache::TILE_SIZE);

    for (int i = 0; i < icCanvasManager::TileCache::TILE_SIZE; i++) {
        for (int j = 0; j < icCanvasManager::TileCache::TILE_SIZE; j++) {
            data[i * cairo_stride + j * 4 + 0] = (uint8_t)(tile_dat[i][j][3] * UINT8_MAX);
            data[i * cairo_stride + j * 4 + 1] = (uint8_t)(tile_dat[i][j][0] * UINT8_MAX);
            data[i * cairo_stride + j * 4 + 2] = (uint8_t)(tile_dat[i][j][1] * UINT8_MAX);
            data[i * cairo_stride + j * 4 + 3] = (uint8_t)(tile_dat[i][j][2] * UINT8_MAX);
        }
    }

    auto* imsurf = cairo_image_surface_create_for_data(data, CAIRO_FORMAT_ARGB32, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE, cairo_stride);

    cairo_surface_set_user_data(imsurf, (cairo_user_data_key_t*)malloc(sizeof(cairo_user_data_key_t)), data, &::freed_imported_tile);

    std::cout << " done." << std::endl;

    return (icCanvasManager::DisplaySuiteTILE)imsurf;
};
