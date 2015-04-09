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
}
