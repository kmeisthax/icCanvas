namespace icCanvasManager {
    namespace GL {
        class ContextManagerObjC : public virtual ContextManager, public virtual RefCnt {
            //this feels wrong
            id<ICMGLContextManager> __strong _objc_delegate;
        public:
            ContextManagerObjC(id<ICMGLContextManager>);

            virtual ContextManager::CONTEXT create_main_context(int major, int minor) override;
            virtual ContextManager::CONTEXT create_sub_context() override;
            virtual void shutdown_sub_context(ContextManager::CONTEXT ctxt) override;
            virtual ContextManager::CONTEXT get_current() override;
            virtual ContextManager::CONTEXT make_current(ContextManager::CONTEXT ctxt, ContextManager::DRAWABLE drawable) override;
            virtual void(*get_proc_address(char* procName)) () override;
            virtual ContextManager::DRAWABLE create_null_drawable() override;
        };
    }
}
