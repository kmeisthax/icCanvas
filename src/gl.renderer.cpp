#include <icCanvasManager.hpp>

icCanvasManager::GL::Renderer::Renderer(icCanvasManager::RefPtr<icCanvasManager::GL::ContextManager> m, icCanvasManager::GL::ContextManager::CONTEXT target, icCanvasManager::GL::ContextManager::DRAWABLE window) {
};
icCanvasManager::GL::Renderer::~Renderer() {
};

/* Create a new tile surface of the renderer's own choosing.
 *
 * At this stage the renderer is not required to place the tile within
 * a Cairo image surface.
 */
void icCanvasManager::GL::Renderer::enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) {
};

/* Given a brushstroke, draw it onto the surface at the specified
 * position and zoom level.
 */
void icCanvasManager::GL::Renderer::draw_stroke(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> br) {
};

/* After rendering has finished, it may be copied to a Cairo image
 * surface of the client's choosing. This may happen in two ways:
 *
 *    The client may provide a compatible cairo_surface_t by
 *    implementing the retrieve_image_surface method and returning
 *    a non-NULL pointer.
 *
 *    The client may copy the current surface into a Cairo surface
 */
cairo_surface_t* icCanvasManager::GL::Renderer::retrieve_image_surface() {

};

void icCanvasManager::GL::Renderer::transfer_to_image_surface(cairo_surface_t* surf) {

};
