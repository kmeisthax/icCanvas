#include <icCanvasManager.hpp>

#include <iostream>
#include <fstream>

#include <PlatformGL.h>

icCanvasManager::GL::Renderer::Renderer(icCanvasManager::RefPtr<icCanvasManager::GL::ContextManager> m, icCanvasManager::GL::ContextManager::CONTEXT target, icCanvasManager::GL::ContextManager::DRAWABLE window) : m(m) {

    this->ex = new icCanvasManager::GL::Extensions();

    /* TODO: Make resource loading work properly without running the program
     * inside the resources directory. */

    std::ifstream iFile;

    iFile.open("resources/shaders/glsl/raymarch.vert.glsl", std::ifstream::in);
    iFile.seekg(0, std::ios::end);
    GLint vertLength = iFile.tellg();
    iFile.seekg(0, std::ios::beg);

    GLchar* vertBuffer = new GLchar[vertLength + 1];
    iFile.read(vertBuffer, vertLength);
    iFile.close();

    vertBuffer[vertLength] = 0;

    m->make_current(target, window);
    this->ex->collect_extensions(this->m);

    this->vShader = this->ex->glCreateShader(GL_VERTEX_SHADER);
    this->ex->glShaderSource(this->vShader, 1, (const GLchar**)&vertBuffer, NULL);
    this->ex->glCompileShader(this->vShader);

    delete[] vertBuffer;

    GLint success = 0;
    this->ex->glGetShaderiv(this->vShader, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
        GLint logSize = 0, getLogSize;
        this->ex->glGetShaderiv(this->vShader, GL_INFO_LOG_LENGTH, &logSize);

        char* vertLog = new char[logSize];
        this->ex->glGetShaderInfoLog(this->vShader, logSize, &getLogSize, vertLog);

        std::cout << "Vertex shader compilation failed!" << std::endl;
        std::cout.write(vertLog, getLogSize);
        std::cout << std::endl;

        this->ex->glDeleteShader(this->vShader);
        delete[] vertLog;
        return;
    }

    iFile.open("resources/shaders/glsl/brushstroke.frag.glsl", std::ifstream::in);
    iFile.seekg(0, std::ios::end);
    GLint fragLength = iFile.tellg();
    iFile.seekg(0, std::ios::beg);

    GLchar* fragBuffer = new GLchar[fragLength + 1];
    iFile.read(fragBuffer, fragLength);
    iFile.close();

    fragBuffer[fragLength] = 0;

    this->fShader = this->ex->glCreateShader(GL_FRAGMENT_SHADER);
    this->ex->glShaderSource(this->fShader, 1, (const GLchar**)&fragBuffer, &fragLength);
    this->ex->glCompileShader(this->fShader);

    delete[] fragBuffer;

    success = 0;
    this->ex->glGetShaderiv(this->fShader, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
        GLint logSize = 0, getLogSize;
        this->ex->glGetShaderiv(this->fShader, GL_INFO_LOG_LENGTH, &logSize);

        char* fragLog = new char[logSize];
        this->ex->glGetShaderInfoLog(this->fShader, logSize, &getLogSize, fragLog);

        std::cout << "Fragment shader compilation failed!\n" << std::endl;
        std::cout.write(fragLog, getLogSize);
        std::cout << std::endl;

        this->ex->glDeleteShader(this->fShader);
        this->ex->glDeleteShader(this->vShader);
        delete[] fragLog;
        return;
    }

    this->dProgram = this->ex->glCreateProgram();
    this->ex->glAttachShader(this->dProgram, this->vShader);
    this->ex->glAttachShader(this->dProgram, this->fShader);

    this->ex->glLinkProgram(this->dProgram);

    success = 0;
    this->ex->glGetProgramiv(this->dProgram, GL_LINK_STATUS, &success);
    if (success == GL_FALSE) {
        GLint logSize = 0;
        this->ex->glGetProgramiv(this->dProgram, GL_INFO_LOG_LENGTH, &logSize);

        char* linkLog = new char[logSize];
        this->ex->glGetProgramInfoLog(this->dProgram, logSize, NULL, linkLog);

        std::cout << "Shader program linking failed!\n" << linkLog << std::endl;

        this->ex->glDeleteProgram(this->dProgram);
        this->ex->glDeleteShader(this->fShader);
        this->ex->glDeleteShader(this->vShader);
        delete[] linkLog;
        return;
    }

    this->ex->glDetachShader(this->dProgram, this->vShader);
    this->ex->glDetachShader(this->dProgram, this->fShader);
    this->ex->glDeleteShader(this->vShader);
    this->ex->glDeleteShader(this->fShader);
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
