#ifndef __ICCANVASMANAGER_GL_EXTENSIONS_HPP__
#define __ICCANVASMANAGER_GL_EXTENSIONS_HPP__

#include "../../icCanvasManager.hpp"

#include <PlatformGL.h>

#ifndef GL_RGBA32F
#define GL_RGBA32F GL_RGBA32F_ARB
#endif

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

            //Texture objects
            void (*glGenTextures)(GLsizei n, GLuint* textures);
            void (*glBindTexture)(GLenum target, GLuint texture);
            void (*glDeleteTextures)(GLsizei n, const GLuint* textures);
            void (*glTexImage1D)(GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLint format, GLenum type, const GLvoid *pixels);
            void (*glTexImage2D)(GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLint format, GLenum type, const GLvoid *pixels);

            //Buffer objects
            void (*glGenBuffers)(GLsizei n, GLuint* ids);
            void (*glDeleteBuffers)(GLsizei n, GLuint* ids);
            void (*glBindBuffer)(GLenum target, GLuint bufferName);
            void (*glBufferData)(GLenum target, GLsizeiptr size, const GLvoid * data, GLenum usage);

            //Vertex Array Objects
            void (*glGenVertexArrays)(GLsizei n, GLuint* ids);
            void (*glDeleteVertexArrays)(GLsizei n, GLuint* ids);
            void (*glBindVertexArray)(GLuint bufferName);
            void (*glEnableVertexAttribArray)(GLuint index);
            void (*glDisableVertexAttribArray)(GLuint index);

            //Vertex specification
            void (*glVertexAttribPointer)(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid * pointer);
            void (*glVertexAttribIPointer)(GLuint index, GLint size, GLenum type, GLsizei stride, const GLvoid * pointer);
            void (*glVertexAttribLPointer)(GLuint index, GLint size, GLenum type, GLsizei stride, const GLvoid * pointer);

            //Shader objects
            GLuint (*glCreateShader)(GLenum shaderType);
            void (*glShaderSource)(GLuint shader, GLsizei count, const GLchar** string, const GLint *length);
            void (*glCompileShader)(GLuint shader);
            void (*glGetShaderiv)(GLuint shader, GLenum pname, GLint *params);
            void (*glGetShaderInfoLog)(GLuint shader, GLsizei maxLength, GLsizei *length, GLchar *infoLog);
            void (*glDeleteShader)(GLuint shader);

            //Program objects
            GLuint (*glCreateProgram)();
            void (*glAttachShader)(GLuint program, GLuint shader);
            void (*glLinkProgram)(GLuint program);
            void (*glGetProgramiv)(GLuint program, GLenum pname, GLint *params);
            void (*glGetProgramInfoLog)(GLuint program, GLsizei maxLength, GLsizei *length, GLchar *infoLog);
            void (*glUseProgram)(GLuint program);
            void (*glDeleteProgram)(GLuint program);
            void (*glDetachShader)(GLuint program, GLuint shader);

            //Program introspection
            void (*glGetActiveAttrib)(GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
            GLint (*glGetAttribLocation)(GLuint program, const GLchar *name);
            GLint (*glGetFragDataLocation)(GLuint program, const char * name);
            GLint (*glGetFragDataIndex)(GLuint program, const char * name);
            void (*glGetUniformIndices)(GLuint program, GLsizei uniformCount, const char ** uniformNames, GLuint *uniformIndices);
            void (*glGetActiveUniformName)( GLuint program, GLuint uniformIndex, GLsizei bufSize, GLsizei *length, char *uniformName);
            void (*glGetActiveUniformsiv)( GLuint program, GLsizei uniformCount, const GLuint *uniformIndices, GLenum pname, GLint *params );
            GLint (*glGetUniformLocation)(GLuint program, const GLchar *name);

            //Uniform I/O
            void (*glUniform1f)(GLint location, GLfloat v0);
            void (*glUniform2f)(GLint location, GLfloat v0, GLfloat v1);
            void (*glUniform3f)(GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
            void (*glUniform4f)(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
            void (*glUniform1i)(GLint location, GLint v0);
            void (*glUniform2i)(GLint location, GLint v0, GLint v1);
            void (*glUniform3i)(GLint location, GLint v0, GLint v1, GLint v2);
            void (*glUniform4i)(GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
            void (*glUniform1ui)(GLint location, GLuint v0);
            void (*glUniform2ui)(GLint location, GLuint v0, GLuint v1);
            void (*glUniform3ui)(GLint location, GLuint v0, GLuint v1, GLuint v2);
            void (*glUniform4ui)(GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3);
            void (*glUniform1fv)(GLint location, GLsizei count, const GLfloat *value);
            void (*glUniform2fv)(GLint location, GLsizei count, const GLfloat *value);
            void (*glUniform3fv)(GLint location, GLsizei count, const GLfloat *value);
            void (*glUniform4fv)(GLint location, GLsizei count, const GLfloat *value);
            void (*glUniform1iv)(GLint location, GLsizei count, const GLint *value);
            void (*glUniform2iv)(GLint location, GLsizei count, const GLint *value);
            void (*glUniform3iv)(GLint location, GLsizei count, const GLint *value);
            void (*glUniform4iv)(GLint location, GLsizei count, const GLint *value);
            void (*glUniform1uiv)(GLint location, GLsizei count, const GLuint *value);
            void (*glUniform2uiv)(GLint location, GLsizei count, const GLuint *value);
            void (*glUniform3uiv)(GLint location, GLsizei count, const GLuint *value);
            void (*glUniform4uiv)(GLint location, GLsizei count, const GLuint *value);
            void (*glUniformMatrix2fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix3fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix4fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix2x3fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix3x2fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix2x4fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix4x2fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix3x4fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
            void (*glUniformMatrix4x3fv)(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);

            //Framebuffer objects
            void (*glGenFramebuffers)(GLsizei n, GLuint* ids);
            void (*glDeleteFramebuffers)(GLsizei n, GLuint *framebuffers);
            void (*glBindFramebuffer)(GLenum target, GLuint framebuffer);
            void (*glFramebufferTexture)(GLenum target, GLenum attachment, GLuint texture, GLint level);
            void (*glFramebufferTexture1D)(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
            void (*glFramebufferTexture2D)(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
            void (*glFramebufferTexture3D)(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint layer);
            GLenum (*glCheckFramebufferStatus)(GLenum target);

            //Back/front buffer configuration
            void (*glDrawBuffer)(GLenum mode);
        };
    }
}

#endif
