#include <icCanvasManager.hpp>

icCanvasManager::GL::Extensions::Extensions() {};
icCanvasManager::GL::Extensions::~Extensions() {};

void icCanvasManager::GL::Extensions::collect_extensions(icCanvasManager::RefPtr<icCanvasManager::GL::ContextManager> m) {
    this->glCreateShader = (decltype(this->glCreateShader))m->get_proc_address("glCreateShader");
    this->glShaderSource = (decltype(this->glShaderSource))m->get_proc_address("glShaderSource");
    this->glCompileShader = (decltype(this->glCompileShader))m->get_proc_address("glCompileShader");
    this->glGetShaderiv = (decltype(this->glGetShaderiv))m->get_proc_address("glGetShaderiv");
    this->glGetShaderInfoLog = (decltype(this->glGetShaderInfoLog))m->get_proc_address("glGetShaderInfoLog");
    this->glDeleteShader = (decltype(this->glDeleteShader))m->get_proc_address("glDeleteShader");
    this->glCreateProgram = (decltype(this->glCreateProgram))m->get_proc_address("glCreateProgram");
    this->glAttachShader = (decltype(this->glAttachShader))m->get_proc_address("glAttachShader");
    this->glLinkProgram = (decltype(this->glLinkProgram))m->get_proc_address("glLinkProgram");
    this->glGetProgramiv = (decltype(this->glGetProgramiv))m->get_proc_address("glGetProgramiv");
    this->glGetProgramInfoLog = (decltype(this->glGetProgramInfoLog))m->get_proc_address("glGetProgramInfoLog");
    this->glDeleteProgram = (decltype(this->glDeleteProgram))m->get_proc_address("glDeleteProgram");
    this->glDetachShader = (decltype(this->glDetachShader))m->get_proc_address("glDetachShader");
    this->glGenFramebuffers = (decltype(this->glGenFramebuffers))m->get_proc_address("glGenFramebuffers");
    this->glDeleteFramebuffers = (decltype(this->glDeleteFramebuffers))m->get_proc_address("glDeleteFramebuffers");
    this->glBindFramebuffer = (decltype(this->glBindFramebuffer))m->get_proc_address("glBindFramebuffer");
    this->glFramebufferTexture = (decltype(this->glFramebufferTexture))m->get_proc_address("glFramebufferTexture");
    this->glFramebufferTexture1D = (decltype(this->glFramebufferTexture1D))m->get_proc_address("glFramebufferTexture1D");
    this->glFramebufferTexture2D = (decltype(this->glFramebufferTexture2D))m->get_proc_address("glFramebufferTexture2D");
    this->glFramebufferTexture3D = (decltype(this->glFramebufferTexture3D))m->get_proc_address("glFramebufferTexture3D");
    this->glCheckFramebufferStatus = (decltype(this->glCheckFramebufferStatus))m->get_proc_address("glCheckFramebufferStatus");
    this->glDrawBuffer = (decltype(this->glDrawBuffer))m->get_proc_address("glDrawBuffer");
    this->glGenTextures = (decltype(this->glGenTextures))m->get_proc_address("glGenTextures");
    this->glBindTexture = (decltype(this->glBindTexture))m->get_proc_address("glBindTexture");
    this->glDeleteTextures = (decltype(this->glDeleteTextures))m->get_proc_address("glDeleteTextures");
    this->glTexImage1D = (decltype(this->glTexImage1D))m->get_proc_address("glTexImage1D");
    this->glTexImage2D = (decltype(this->glTexImage2D))m->get_proc_address("glTexImage2D");
    this->glGenBuffers = (decltype(this->glGenBuffers))m->get_proc_address("glGenBuffers");
    this->glDeleteBuffers = (decltype(this->glDeleteBuffers))m->get_proc_address("glDeleteBuffers");
    this->glBindBuffer = (decltype(this->glBindBuffer))m->get_proc_address("glBindBuffer");
    this->glBufferData = (decltype(this->glBufferData))m->get_proc_address("glBufferData");
    this->glVertexAttribPointer = (decltype(this->glVertexAttribPointer))m->get_proc_address("glVertexAttribPointer");
    this->glVertexAttribIPointer = (decltype(this->glVertexAttribIPointer))m->get_proc_address("glVertexAttribIPointer");
    this->glVertexAttribLPointer = (decltype(this->glVertexAttribLPointer))m->get_proc_address("glVertexAttribLPointer");
    this->glGenVertexArrays = (decltype(this->glGenVertexArrays))m->get_proc_address("glGenVertexArrays");
    this->glDeleteVertexArrays = (decltype(this->glDeleteVertexArrays))m->get_proc_address("glDeleteVertexArrays");
    this->glBindVertexArray = (decltype(this->glBindVertexArray))m->get_proc_address("glBindVertexArray");
    this->glEnableVertexAttribArray = (decltype(this->glEnableVertexAttribArray))m->get_proc_address("glEnableVertexAttribArray");
    this->glDisableVertexAttribArray = (decltype(this->glDisableVertexAttribArray))m->get_proc_address("glDisableVertexAttribArray");
    //this-> = (decltype(this->))m->get_proc_address("");
}
