#import <Cocoa/Cocoa.h>

@interface ICMGLDisplaySuite : ICMDisplaySuite

- (id)initWithContextManager:(id <ICMGLContextManager>)m andNullDrawable:(intptr_t)drawable;
- (id)initFromWrappedObject:(void*)optr;

- (void*)getWrappedObject;

@end
