#import <Cocoa/Cocoa.h>

@interface ICMGLRenderer : ICMRenderer

- (id)initWithContextManager:(id <ICMGLContextManager>)m andContext:(intptr_t)ctxt andDrawable:(intptr_t)drawable;
- (id)initFromWrappedObject:(void*)optr;

- (void*)getWrappedObject;

@end
