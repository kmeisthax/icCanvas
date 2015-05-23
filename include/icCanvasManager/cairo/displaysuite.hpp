#ifndef __ICCANVASMANAGER_CAIRO_DISPLAYSUITE_HPP__
#define __ICCANVASMANAGER_CAIRO_DISPLAYSUITE_HPP__

#include "../../icCanvasManager.hpp"

#include <cairo.h>
#include <cstdint>

namespace icCanvasManager {
    namespace Cairo {
        /* DisplaySuite for legacy Cairo renderer.
         */
        class DisplaySuite : public virtual RefCnt, public virtual icCanvasManager::DisplaySuite {
        public:
            DisplaySuite();
            virtual ~DisplaySuite();

            /* DisplaySuite impl */
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
