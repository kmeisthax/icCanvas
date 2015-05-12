#import <Cocoa/Cocoa.h>

@interface ICAKGLContextManager : NSObject <ICMGLContextManager>

- (id)init;

- (intptr_t)createMainContextWithVersionMajor:(int)major andMinor:(int)minor;
- (intptr_t)createSubContext;
- (void)shutdownSubContext:(intptr_t)ctxt;
- (intptr_t)makeCurrent:(intptr_t)ctxt withDrawable:(intptr_t)draw;
- (intptr_t)getCurrent;
- (void (*)())getProcAddress:(char*)procName;
- (intptr_t)getNullDrawable;

@end
