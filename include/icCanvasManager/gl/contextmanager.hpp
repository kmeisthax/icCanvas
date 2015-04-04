#ifndef __ICCANVASMANAGER_GL_CONTEXTMANAGER_HPP__
#define __ICCANVASMANAGER_GL_CONTEXTMANAGER_HPP__

#include "../../icCanvasManager.hpp"

#include <cstdint>

namespace icCanvasManager {
    namespace GL {
        /* Virtualized API for managing OpenGL contexts across multiple OpenGL APIs
         * and window systems.
         */
        class ContextManager : public virtual RefCnt {
        protected:
            ContextManager();
        public:
            virtual ~ContextManager();

            /* Implementation-defined context type.
             *
             * This is defined as an integer as wide as void* (effectively, any
             * pointer-to-POD on most architectures) and can store an integer
             * directly or a pointer to a larger structure.
             *
             * If this type is a pointer, it points to memory entirely owned by
             * the GLContextManager and should not be accessed outside of this
             * class, nor deallocated. The implementation is responsible for
             * managing all pointed-at memory, smart pointer reference counting,
             * garbage collection, whatever deep voodoo you have to do in order to
             * fool a C program into blindly passing NSOpenGLContext around, etc.
             */
            typedef intptr_t CONTEXT;

            /* The main context is the first context created by the manager.
             * A GLContextManager will only provide one main context per
             * instance which is created the first time this function is called.
             *
             * The major and minor arguments specify what OpenGL version is being
             * requested.
             */
            virtual CONTEXT create_main_context(int major, int minor) = 0;

            /* A sub context is an additional rendering context which shares
             * certain state with the main contexts, namely:
             *
             *   - Display lists
             *   - Texture objects
             *   - Renderbuffers
             *   - Buffer objects
             *
             * Subcontexts are created with the same version arguments as the main
             * context.
             */
            virtual CONTEXT create_sub_context() = 0;
            virtual void shutdown_sub_context(CONTEXT ctxt) = 0;

            /* Like CONTEXT, but for possible drawing targets.
             *
             * Each DRAWABLE becomes the default framebuffer for OpenGL within that
             * context.
             */
            typedef intptr_t DRAWABLE;

            /* Get the current context.
             */
            virtual CONTEXT get_current() = 0;

            /* Make the provided context current.
             *
             * The provided DRAWABLE becomes the default framebuffer for the
             * context.
             *
             * There is no platform-generic way to create a DRAWABLE - you must
             * solicit one from the frontend, even if you only intend to draw to
             * off-screen buffers.
             */
            virtual CONTEXT make_current(CONTEXT ctxt, DRAWABLE drawable) = 0;
        };
    }
}

#endif
