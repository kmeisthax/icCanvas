#ifndef __ICCANVASMANAGER_GL_EXTENSIONS_HPP__
#define __ICCANVASMANAGER_GL_EXTENSIONS_HPP__

#include "../../icCanvasManager.hpp"

#include <PlatformGL.h>

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

            /* Extension pointers. */
            GLuint (*glCreateShader)(GLenum shaderType);
            void (*glShaderSource)(GLuint shader, GLsizei count, const GLchar** string, const GLint *length);
            void (*glCompileShader)(GLuint shader);
            void (*glGetShaderiv)(GLuint shader, GLenum pname, GLint *params);
            void (*glGetShaderInfoLog)(GLuint shader, GLsizei maxLength, GLsizei *length, GLchar *infoLog);
            void (*glDeleteShader)(GLuint shader);
            GLuint (*glCreateProgram)();
            void (*glAttachShader)(GLuint program, GLuint shader);
            void (*glLinkProgram)(GLuint program);
            void (*glGetProgramiv)(GLuint program, GLenum pname, GLint *params);
            void (*glGetProgramInfoLog)(GLuint program, GLsizei maxLength, GLsizei *length, GLchar *infoLog);
            void (*glDeleteProgram)(GLuint program);
            void (*glDetachShader)(GLuint program, GLuint shader);
        };
    }
}

#endif
