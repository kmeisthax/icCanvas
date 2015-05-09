#ifndef __ICCANVASMANAGER_GL_RENDERER_HPP__
#define __ICCANVASMANAGER_GL_RENDERER_HPP__

#include "../../icCanvasManager.hpp"

#include <cairo.h>
#include <PlatformGL.h>
#include <cstdint>

namespace icCanvasManager {
    namespace GL {
        class DisplaySuite: public virtual icCanvasManager::DisplaySuite {
            RefPtr<ContextManager> cman;
            ContextManager::CONTEXT renderer_context;
            ContextManager::DRAWABLE null_drawable;

        public:
            DisplaySuite(ContextManager *cman, ContextManager::DRAWABLE null_drawable);
            virtual ~DisplaySuite() override;

            /* DisplaySuite impls */
            virtual void report_concurrency_level(ConcurrencyLevel *out_renderer_lvl, ConcurrencyLevel *out_presenter_lvl) override;
            virtual Renderer* create_renderer() override;
            virtual void free_tile(TILE tile) override;
            virtual bool can_direct_transfer(DisplaySuite *other) override;
            virtual TILE direct_transfer(DisplaySuite* other, TILE tile, bool copy_bit) override;
            virtual TileCache::TileData* export_tile(TILE tile) override;
            virtual TILE import_tile(TileCache::TileData *tile_dat) override;
        }
    }
}

#endif
