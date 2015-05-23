#include <icCanvasManager.hpp>

#include <iostream>
#include <fstream>

#include <PlatformGL.h>

static float __raymarchVertData[16] = {-1,-1,0,1,
                                        1,-1,0,1,
                                       -1, 1,0,1,
                                        1, 1,0,1};

icCanvasManager::GL::Renderer::Renderer(icCanvasManager::RefPtr<icCanvasManager::GL::ContextManager> m, icCanvasManager::GL::ContextManager::CONTEXT target, icCanvasManager::GL::ContextManager::DRAWABLE window) : m(m) {
    //Wrangle extensions
    this->ex = new icCanvasManager::GL::Extensions();

    m->make_current(target, window);
    this->ex->collect_extensions(this->m);

    /* TODO: Make resource loading work properly without running the program
     * inside the resources directory. */

    //Create BrushStroke rendering function
    std::ifstream iFile;

    iFile.open("resources/shaders/glsl/raymarch.vert.glsl", std::ifstream::in);
    iFile.seekg(0, std::ios::end);
    GLint vertLength = iFile.tellg();
    iFile.seekg(0, std::ios::beg);

    GLchar* vertBuffer = new GLchar[vertLength + 1];
    iFile.read(vertBuffer, vertLength);
    iFile.close();

    vertBuffer[vertLength] = 0;

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

    //Create "raymarch" quad (i.e. screen-filling so we can raster all points
    //however we like)
    this->ex->glGenBuffers(1, &this->raymarchVertex);
    this->ex->glBindBuffer(GL_ARRAY_BUFFER, this->raymarchVertex);
    this->ex->glBufferData(GL_ARRAY_BUFFER, sizeof(::__raymarchVertData), &::__raymarchVertData, GL_STATIC_DRAW);

    this->ex->glGenVertexArrays(1, &this->raymarchGeom);
    this->ex->glBindVertexArray(this->raymarchGeom);

    GLint positionLoc = this->ex->glGetAttribLocation(this->dProgram, "vPos");
    this->ex->glVertexAttribPointer(positionLoc, 4, GL_FLOAT, GL_TRUE, 0, (void*)0);

    this->ex->glBindVertexArray(0);
    this->ex->glBindBuffer(GL_ARRAY_BUFFER, 0);

    //Create framebuffer object
    this->ex->glGenFramebuffers(1, &this->renderTarget);
    this->ex->glBindFramebuffer(GL_FRAMEBUFFER, this->renderTarget);

    this->ex->glGenTextures(1, &this->renderColorTexture);
    this->ex->glBindTexture(GL_TEXTURE_2D, this->renderColorTexture);

    this->ex->glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE, 0, GL_RGBA, GL_FLOAT, NULL);

    this->ex->glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, this->renderColorTexture, 0);

    assert(this->ex->glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE);

    this->ex->glBindFramebuffer(GL_FRAMEBUFFER, 0);
    this->ex->glBindTexture(GL_TEXTURE_2D, 0);

    auto error = this->ex->glGetError();
    assert(error == GL_NO_ERROR);
};

icCanvasManager::GL::Renderer::~Renderer() {
};

/* Create a new tile surface of the renderer's own choosing.
 *
 * At this stage the renderer is not required to place the tile within
 * a Cairo image surface.
 */
static const float __clearColor[4] = {0.0f, 0.0f, 0.0f, 1.0f};

void icCanvasManager::GL::Renderer::enter_new_surface(const int32_t x, const int32_t y, const int32_t zoom) {
    this->x = x;
    this->y = y;
    this->zoom = std::min(zoom, 31);

    this->tw = icCanvasManager::TileCache::TILE_SIZE;
    this->th = icCanvasManager::TileCache::TILE_SIZE;

    int64_t size = UINT32_MAX >> this->zoom;
    this->xmin = x - (size >> 1);
    this->ymin = y - (size >> 1);

    this->xscale = (float)this->tw / (float)size;
    this->yscale = (float)this->th / (float)size;

    this->xmax = x + (size >> 1);
    this->ymax = y + (size >> 1);

    this->ex->glBindFramebuffer(GL_DRAW_FRAMEBUFFER, this->renderTarget);

    //Clear the active framebuffer.
    this->ex->glClearBufferfv(GL_COLOR, 0, ::__clearColor);

    //Set up additional uniforms used by the fragment shader.
    GLint tileParamsLoc, surfaceParamsLoc, tScaleParamsLoc, tMinMaxParamsLoc;

    this->ex->glUseProgram(this->dProgram);

    tileParamsLoc = this->ex->glGetUniformLocation(this->dProgram, "tileParams");
    surfaceParamsLoc = this->ex->glGetUniformLocation(this->dProgram, "surfaceParams");
    tScaleParamsLoc = this->ex->glGetUniformLocation(this->dProgram, "tScaleParams");
    tMinMaxParamsLoc = this->ex->glGetUniformLocation(this->dProgram, "tMinMaxParams");

    if (tileParamsLoc != -1) {
        this->ex->glUniform3i(tileParamsLoc, this->x, this->y, this->zoom);
    }

    if (surfaceParamsLoc != -1) {
        this->ex->glUniform2i(surfaceParamsLoc, this->tw, this->th);
    }

    if (tScaleParamsLoc != -1) {
        this->ex->glUniform2f(tScaleParamsLoc, this->xscale, this->yscale);
    }

    if (tMinMaxParamsLoc != -1) {
        this->ex->glUniform4i(tMinMaxParamsLoc, this->xmin, this->xmax, this->ymin, this->ymax);
    }

    auto error = this->ex->glGetError();
    assert(error == GL_NO_ERROR);
};

/* Given a brushstroke, draw it onto the surface at the specified
 * position and zoom level.
 */
void icCanvasManager::GL::Renderer::draw_stroke(icCanvasManager::RefPtr<icCanvasManager::BrushStroke> br) {
    GLuint strokeInfoTex[2];

    this->ex->glGenTextures(2, strokeInfoTex);

    //Pull the brushstroke information out into a texture.
    size_t strokeTexSize = br->_curve.count_points() * 4 * 2; //Number of texels
    int32_t *strokeTexMem = (int32_t*)malloc(strokeTexSize * 4 * sizeof(int32_t)); //Actual texture memory

    for (int i = 0; i < br->_curve.count_points(); i++) { //Forall polynomials
        for (int j = 0; j < 4; j++) { //Forall control points
            int base_component = i * 4 * 2 * 4 + j * 2 * 4;
            auto &cpt = br->_curve.get_point(i, j);

            strokeTexMem[base_component] = cpt.x;
            strokeTexMem[base_component + 1] = cpt.y;
            strokeTexMem[base_component + 2] = cpt.dx;
            strokeTexMem[base_component + 3] = cpt.dy;
            strokeTexMem[base_component + 4] = cpt.tilt;
            strokeTexMem[base_component + 5] = cpt.angle;
            strokeTexMem[base_component + 6] = cpt.pressure;
            strokeTexMem[base_component + 7] = 0;
        }
    }

    this->ex->glBindTexture(GL_TEXTURE_1D, strokeInfoTex[0]);
    this->ex->glTexImage1D(GL_TEXTURE_1D, 0, GL_RGBA32I, strokeTexSize, 0, GL_RGBA_INTEGER, GL_INT, strokeTexMem);

    //Pull the derivative stroke information into a texture.
    auto curveDeriv = br->_curve.derivative();
    size_t strokeDerivTexSize = curveDeriv.count_points() * 3 * 2; //Number of texels
    int32_t *strokeDerivTexMem = (int32_t*)malloc(strokeDerivTexSize * 4 * sizeof(int32_t)); //Actual texture memory

    for (int i = 0; i < curveDeriv.count_points(); i++) { //Forall polynomials
        for (int j = 0; j < 3; j++) { //Forall control points
            int base_component = i * 3 * 2 * 4 + j * 2 * 4;
            auto &cpt = curveDeriv.get_point(i, j);

            strokeDerivTexMem[base_component] = cpt.x;
            strokeDerivTexMem[base_component + 1] = cpt.y;
            strokeDerivTexMem[base_component + 2] = cpt.dx;
            strokeDerivTexMem[base_component + 3] = cpt.dy;
            strokeDerivTexMem[base_component + 4] = cpt.tilt;
            strokeDerivTexMem[base_component + 5] = cpt.angle;
            strokeDerivTexMem[base_component + 6] = cpt.pressure;
            strokeDerivTexMem[base_component + 7] = 0;
        }
    }

    this->ex->glBindTexture(GL_TEXTURE_1D, strokeInfoTex[1]);
    this->ex->glTexImage1D(GL_TEXTURE_1D, 0, GL_RGBA32I, strokeDerivTexSize, 0, GL_RGBA_INTEGER, GL_INT, strokeDerivTexMem);

    //Set up the "raymarch" quad so we can raster over the whole tile.
    this->ex->glBindVertexArray(this->raymarchGeom);

    //Set up our framebuffer target.
    this->ex->glBindFramebuffer(GL_DRAW_FRAMEBUFFER, this->renderTarget);

    //Set up our shader program.
    this->ex->glUseProgram(this->dProgram);

    //Set up per-stroke uniforms.
    GLint splineDataLoc, splineDerivativeDataLoc, tintOpacityLoc, brushSizeLoc;
    splineDataLoc = this->ex->glGetUniformLocation(this->dProgram, "splineData");
    splineDerivativeDataLoc = this->ex->glGetUniformLocation(this->dProgram, "splineDerivativeData");
    tintOpacityLoc = this->ex->glGetUniformLocation(this->dProgram, "tintOpacity");
    brushSizeLoc = this->ex->glGetUniformLocation(this->dProgram, "brushSize");

    if (splineDataLoc != -1) {
        this->ex->glUniform1i(splineDataLoc, 0);
        this->ex->glActiveTexture(GL_TEXTURE0 + 0);
        this->ex->glBindTexture(GL_TEXTURE_1D, strokeInfoTex[0]);
    }

    if (splineDerivativeDataLoc != -1) {
        this->ex->glUniform1i(splineDerivativeDataLoc, 1);
        this->ex->glActiveTexture(GL_TEXTURE0 + 1);
        this->ex->glBindTexture(GL_TEXTURE_1D, strokeInfoTex[1]);
    }

    if (tintOpacityLoc != -1) {
        auto premulR = ((float)br->_tint_color_red / icCanvasManager::BrushStroke::COLOR_MAX) * ((float)br->_tint_alpha / icCanvasManager::BrushStroke::COLOR_MAX);
        auto premulG = ((float)br->_tint_color_green / icCanvasManager::BrushStroke::COLOR_MAX) * ((float)br->_tint_alpha / icCanvasManager::BrushStroke::COLOR_MAX);
        auto premulB = ((float)br->_tint_color_blue / icCanvasManager::BrushStroke::COLOR_MAX) * ((float)br->_tint_alpha / icCanvasManager::BrushStroke::COLOR_MAX);

        this->ex->glUniform4f(tintOpacityLoc, premulR, premulG, premulB, ((float)br->_tint_alpha / icCanvasManager::BrushStroke::COLOR_MAX));
    }

    if (brushSizeLoc != -1) {
        this->ex->glUniform1i(brushSizeLoc, br->_base_thickness);
    }

    this->ex->glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    //Cleanup some GL state.
    this->ex->glBindVertexArray(0);
    this->ex->glActiveTexture(GL_TEXTURE0);
    this->ex->glUseProgram(0);
    this->ex->glBindTexture(GL_TEXTURE_1D, 0);
    this->ex->glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);

    this->ex->glDeleteTextures(2, strokeInfoTex);

    auto error = this->ex->glGetError();
    assert(error == GL_NO_ERROR);
};

icCanvasManager::DisplaySuiteTILE icCanvasManager::GL::Renderer::copy_to_tile() {
    GLuint newTex;
    this->ex->glGenTextures(1, &newTex);

    this->ex->glBindFramebuffer(GL_READ_FRAMEBUFFER, this->renderTarget);
    this->ex->glBindTexture(GL_TEXTURE_2D, newTex);

    this->ex->glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE, 0, GL_RGBA, GL_FLOAT, NULL);
    this->ex->glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, 0, 0, icCanvasManager::TileCache::TILE_SIZE, icCanvasManager::TileCache::TILE_SIZE, 0);

    auto error = this->ex->glGetError();
    assert(error == GL_NO_ERROR);

    this->ex->glBindTexture(GL_TEXTURE_2D, 0);
    this->ex->glBindFramebuffer(GL_READ_FRAMEBUFFER, 0);

    return (DisplaySuiteTILE)newTex;
};
