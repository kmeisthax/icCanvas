#include <icCanvasAppKit.h>

//To emulate *gl*GetProcAddress
#import <mach-o/dyld.h>
#import <stdlib.h>
#import <string.h>

@implementation ICAKGLContextManager {
    NSOpenGLPixelFormat *_pFormat;
    NSOpenGLContext *_ctxt;

    //ICMGLContextManager is an API designed to work with manually-managed
    //contexts. Apple uses reference counting for them, so we need to store the
    //pointer somewhere.
    NSMutableArray *_subctxt;
}

- (id)init {
    self = [super init];

    if (self != nil) {
        self->_subctxt = [[NSMutableArray alloc] init];
    }

    return self;
}

- (intptr_t)createMainContextWithVersionMajor:(int)major andMinor:(int)minor {
    NSOpenGLPixelFormatAttribute glVersion = NSOpenGLProfileVersion3_2Core;
    if (major < 3) glVersion = NSOpenGLProfileVersionLegacy;

    NSOpenGLPixelFormatAttribute pfAttrs[] = {
        NSOpenGLPFAOpenGLProfile, glVersion,
        NSOpenGLPFAMaximumPolicy,
        NSOpenGLPFAColorSize, 24,
        0,
    };

    self->_pFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:pfAttrs];
    if (self->_pFormat == nil) {
        return 0;
    }

    self->_ctxt = [[NSOpenGLContext alloc] initWithFormat:self->_pFormat shareContext:NULL];
    if (self->_ctxt == nil) {
        return 0;
    }

    return (intptr_t)&self->_ctxt;
};

- (intptr_t)createSubContext {
    NSOpenGLContext *subctxt;
    subctxt = [[NSOpenGLContext alloc] initWithFormat:self->_pFormat shareContext:self->_ctxt];
    if (subctxt == nil) {
        return 0;
    }

    [self->_subctxt addObject:subctxt];

    return (intptr_t)(__bridge void*)subctxt;
};

- (void)shutdownSubContext:(intptr_t)ctxt {
    [self->_subctxt removeObject:(__bridge NSOpenGLContext*)(void*)ctxt];
};

- (intptr_t)makeCurrent:(intptr_t)ctxt withDrawable:(intptr_t)draw {
    NSOpenGLContext *c = (NSOpenGLContext*)c;
    NSView *d = (NSView*)d;

    c.view = d;
    [c makeCurrentContext];

    return [self getCurrent];
};

- (intptr_t)getCurrent {
    return (intptr_t)NSOpenGLContext.currentContext;
};

- (void (*)())getProcAddress:(char*)name {
    //TODO: Apple doesn't actually have a getProcAddress equivalent.
    //You just call blindly into various functions.
    //The following is slightly-modified Apple sample code -
    //apparantly they recommend just reading the Mach-O symbol table directly!!

    NSSymbol symbol;
    char *symbolName;
    symbolName = malloc (strlen (name) + 2); // 1
    strcpy(symbolName + 1, name); // 2
    symbolName[0] = '_'; // 3
    symbol = NULL;
    if (NSIsSymbolNameDefined (symbolName)) // 4
    symbol = NSLookupAndBindSymbol (symbolName);
    free (symbolName); // 5
    return symbol ? NSAddressOfSymbol (symbol) : NULL;
};

@end
