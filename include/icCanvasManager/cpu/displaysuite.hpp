#ifndef __ICCANVASMANAGER_CPU_DISPLAYSUITE_HPP__
#define __ICCANVASMANAGER_CPU_DISPLAYSUITE_HPP__

#include "../../icCanvasManager.hpp"

#include <cstdint>

namespace icCanvasManager {
    namespace CPU {
        class DisplaySuite: public virtual icCanvasManager::DisplaySuite {
        public:
            DisplaySuite(ContextManager *cman, ContextManager::DRAWABLE null_drawable);
            virtual ~DisplaySuite() override;

            /* DisplaySuite impls */
            virtual void report_concurrency_level(ConcurrencyLevel *out_renderer_lvl, ConcurrencyLevel *out_presenter_lvl) override;
            virtual icCanvasManager::Renderer* create_renderer() override;
            virtual void free_tile(DisplaySuiteTILE tile) override;
            virtual bool can_direct_transfer(icCanvasManager::DisplaySuite *other) override;
            virtual DisplaySuiteTILE direct_transfer(icCanvasManager::DisplaySuite* other, DisplaySuiteTILE tile, bool copy_bit) override;
            virtual icCanvasManager::TileCache::TileData export_tile(DisplaySuiteTILE tile) override;
            virtual DisplaySuiteTILE import_tile(TileCache::TileData tile_dat) override;
        };
    }
}

#endif
