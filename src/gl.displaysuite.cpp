#include <icCanvasManager.hpp>

#include <PlatformGL.h>

icCanvasManager::GL::DisplaySuite::DisplaySuite(icCanvasManager::GL::ContextManager *cman, icCanvasManager::GL::ContextManager::DRAWABLE null_drawable) : cman(cman), null_drawable(null_drawable), renderer_context(0) {
    this->ex = new icCanvasManager::GL::Extensions();
};
icCanvasManager::GL::DisplaySuite::~DisplaySuite() {
    //TODO: Shut down any contexts we create.
};

/* DisplaySuite impls */
void icCanvasManager::GL::DisplaySuite::report_concurrency_level(icCanvasManager::DisplaySuite::ConcurrencyLevel *out_renderer_lvl, icCanvasManager::DisplaySuite::ConcurrencyLevel *out_presenter_lvl) {
    if (out_renderer_lvl) *out_renderer_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_SINGLE_THREAD;
    if (out_presenter_lvl) *out_presenter_lvl = icCanvasManager::DisplaySuite::CONCURRENCY_MAIN_THREAD_ONLY;
};

icCanvasManager::Renderer* icCanvasManager::GL::DisplaySuite::create_renderer() {
    if (this->renderer_context == 0) {
        this->renderer_context = this->cman->create_main_context(3,0);
        this->ex->collect_extensions(this->cman);
    }

    auto *renderer = new icCanvasManager::GL::Renderer(this->cman, this->renderer_context, this->null_drawable);
    return renderer;
};

void icCanvasManager::GL::DisplaySuite::free_tile(icCanvasManager::DisplaySuite::TILE tile) {
    if (this->renderer_context == 0) {
        this->renderer_context = this->cman->create_main_context(3,0);
        this->ex->collect_extensions(this->cman);
    }

    GLuint texture = (GLuint)tile;
    this->ex->glDeleteTextures(1, &texture);
};

//We don't support any direct transfer paths yet.
bool icCanvasManager::GL::DisplaySuite::can_direct_transfer(icCanvasManager::DisplaySuite *other) {
    return false;
};

icCanvasManager::DisplaySuite::TILE icCanvasManager::GL::DisplaySuite::direct_transfer(icCanvasManager::DisplaySuite* other, icCanvasManager::DisplaySuite::TILE tile, bool copy_bit) {
    return 0;
};

icCanvasManager::TileCache::TileData* icCanvasManager::GL::DisplaySuite::export_tile(icCanvasManager::DisplaySuite::TILE tile) {
    //TODO: Implement tile export.
    return NULL;
};

icCanvasManager::DisplaySuite::TILE icCanvasManager::GL::DisplaySuite::import_tile(icCanvasManager::TileCache::TileData *tile_dat) {
    //TODO: Implement tile import
    return 0;
};
