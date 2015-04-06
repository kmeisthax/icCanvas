#include <icCanvasManager.hpp>

#include <iostream>
#include <fstream>

#include <PlatformGL.h>

icCanvasManager::GL::Renderer::Renderer(icCanvasManager::RefPtr<icCanvasManager::GL::ContextManager> m, icCanvasManager::GL::ContextManager::CONTEXT target, icCanvasManager::GL::ContextManager::DRAWABLE window) {

    /* TODO: Make resource loading work properly without running the program
     * inside the resources directory. */

    std::ifstream iFile;

    iFile.open("resources/shaders/glsl/raymarch.vert.glsl", std::ifstream::in);
    iFile.seekg(0, std::ios::end);
    vertLength = iFile.tellg();
    iFile.seekg(0, std::ios::beg);

    char* vertBuffer = new char[vertLength];
    iFile.read(vertBuffer, length);
    iFile.close();

    m->make_current(target, drawable);

    this->vShader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(this->vShader, 1, &vertBuffer, &length);
    glCompileShader(this->vShader);

    delete[] vertBuffer;

    GLint success = 0;
    glGetShaderiv(this->vShader, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
        GLint logSize = 0;
        glGetShaderiv(this->vShader, GL_INFO_LOG_LENGTH, &logSize);

        char* vertLog = new char[logSize];
        glGetShaderInfoLog(this->vShader, logSize, NULL, vertLog);

        std::cout << vertLog << std::endl;

        glDeleteShader(this->vShader);
        delete[] vertLog;
        return;
    }

    iFile.open("resources/shaders/glsl/brushstroke.frag.glsl", std::ifstream::in);
    iFile.seekg(0, std::ios::end);
    auto fragLength = iFile.tellg();
    iFile.seekg(0, std::ios::beg);

    char* fragBuffer = new char[fragLength];
    iFile.read(fragBuffer, length);
    iFile.close();

    this->fShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(this->fShader, 1, &buffer, &length);
    glCompileShader(this->fShader);

    delete[] fragBuffer;

    success = 0;
    glGetShaderiv(this->fShader, GL_COMPILE_STATUS, &success);
    if (success == GL_FALSE) {
        GLint logSize = 0;
        glGetShaderiv(this->fShader, GL_INFO_LOG_LENGTH, &logSize);

        char* fragLog = new char[logSize];
        glGetShaderInfoLog(this->fShader, logSize, NULL, fragLog);

        std::cout << fragLog << std::endl;

        glDeleteShader(this->fShader);
        glDeleteShader(this->vShader);
        delete[] fragLog;
        return;
    }

    this->dProgram = glCreateProgram();
    glAttachShader(this->dProgram, this->vShader);
    glAttachShader(this->dProgram, this->fShader);

    glLinkProgram(this->dProgram);

    success = 0;
    glGetProgramiv(this->dProgram, GL_LINK_STATUS, &success);
    if (success == GL_FALSE) {
        GLint logSize = 0;
        glGetProgramiv(this->dProgram, GL_INFO_LOG_LENGTH, &logSize);

        char* linkLog = new char[logSize];
        glGetProgramInfoLog(this->dProgram, logSize, NULL, linkLog);

        std::cout << linkLog << std::endl;

        glDeleteProgram(this->dProgram);
        glDeleteShader(this->fShader);
        glDeleteShader(this->vShader);
        delete[] linkLog;
        return;
    }

    glDetachShader(this->dProgram, this->vShader);
    glDetachShader(this->dProgram, this->fShader);
    glDeleteShader(this->vShader);
    glDeleteShader(this->fShader);
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
