#import <Cocoa/Cocoa.h>

@protocol ICMGLContextManager

- (intptr_t)createMainContextWithVersionMajor:(int)major andMinor:(int)minor;
- (intptr_t)createSubContext;
- (void)shutdownSubContext:(intptr_t)ctxt;
- (intptr_t)makeCurrent:(intptr_t)ctxt withDrawable:(intptr_t)draw;
- (intptr_t)getCurrent;
- (void (*)())getProcAddress:(char*)procName;
- (intptr_t)createNullDrawable;

@end
