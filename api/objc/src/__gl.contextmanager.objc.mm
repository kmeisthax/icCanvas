#include <icCanvasManager.hpp>
#import <icCanvasManagerObjC.h>

#import <__icCanvasManagerObjCBridge.hpp>

icCanvasManager::GL::ContextManagerObjC::ContextManagerObjC(id<ICMGLContextManager> objc_delegate) : _objc_delegate(objc_delegate) {};

icCanvasManager::GL::ContextManager::CONTEXT icCanvasManager::GL::ContextManagerObjC::create_main_context(int major, int minor) {
    return [this->_objc_delegate createMainContextWithVersionMajor:major andMinor:minor];
};

icCanvasManager::GL::ContextManager::CONTEXT icCanvasManager::GL::ContextManagerObjC::create_sub_context() {
    return [this->_objc_delegate createSubContext];
};

void icCanvasManager::GL::ContextManagerObjC::shutdown_sub_context(icCanvasManager::GL::ContextManager::CONTEXT ctxt) {
    [this->_objc_delegate shutdownSubContext:ctxt];
};

icCanvasManager::GL::ContextManager::CONTEXT icCanvasManager::GL::ContextManagerObjC::get_current() {
    return [this->_objc_delegate getCurrent];
};

icCanvasManager::GL::ContextManager::CONTEXT icCanvasManager::GL::ContextManagerObjC::make_current(icCanvasManager::GL::ContextManager::CONTEXT ctxt, DRAWABLE drawable) {
    return [this->_objc_delegate makeCurrent:ctxt withDrawable:drawable];
};

void(*icCanvasManager::GL::ContextManagerObjC::get_proc_address(char* procName)) () {
    return [this->_objc_delegate getProcAddress:procName];
};

icCanvasManager::GL::ContextManager::DRAWABLE icCanvasManager::GL::ContextManagerObjC::create_null_drawable() {
    return [this->_objc_delegate createNullDrawable];
};
