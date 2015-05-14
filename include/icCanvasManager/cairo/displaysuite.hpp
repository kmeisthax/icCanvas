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
            virtual void free_tile(TILE tile) override;
            virtual bool can_direct_transfer(icCanvasManager::DisplaySuite *other) override;
            virtual TILE direct_transfer(icCanvasManager::DisplaySuite* other, TILE tile, bool copy_bit) override;
            virtual TileCache::TileData* export_tile(TILE tile) override;
            virtual TILE import_tile(TileCache::TileData *tile_dat) override;
        };
    }
}

#endif
