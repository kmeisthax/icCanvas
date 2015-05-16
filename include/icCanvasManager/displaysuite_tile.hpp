#ifndef __ICCANVASMANAGER__DISPLAYSUITE_TILE_HPP__
#define __ICCANVASMANAGER__DISPLAYSUITE_TILE_HPP__

#include "../icCanvasManager.hpp"

#include <cstdint>

namespace icCanvasManager {
    class DisplaySuite;

    /* A TILE is an abstract type to refer to a platform-specific name for
     * a tile's rendered image representation. It is large enough to store
     * a pointer, therefore, if it is not large enough, you may allocate
     * memory to store your larger structure and return the pointer.
     *
     * TILEs are not reference counted and it is the responsibility of the
     * DisplaySuite's client to deallocate TILEs when they are no longer in
     * use.
     */
    typedef intptr_t DisplaySuiteTILE;
}

#endif
