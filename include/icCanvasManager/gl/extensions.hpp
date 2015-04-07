#ifndef __ICCANVASMANAGER_GL_CONTEXTMANAGER_HPP__
#define __ICCANVASMANAGER_GL_CONTEXTMANAGER_HPP__

#include "../../icCanvasManager.hpp"

#include <GL/gl.h>

namespace icCanvasManager {
    namespace GL {
        /* Class for storing extension functions that we want to use.
         */
        class Extensions : public virtual RefCnt {
        public:
            typedef void (*extension_func)();

            Extensions();
            virtual ~Extensions();

            /* Called to obtain extensions from the current context.
             *
             * The context manager m is used to obtain extension function
             * pointers.
             *
             * Once called, all available extensions will be filled with either
             * a valid function pointer or NULL. NULL functions are not
             * implemented within the current context; otherwise, valid
             * function pointers must not be called outside of the GL context
             * they were obtained from.
             */
            void collect_extensions(RefPtr<ContextManager> m);
        }
    }
}

#endif
