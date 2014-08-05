#include <icCanvasAppKit.h>

@implementation ICAKDrawing {
    ICMDrawing* internal_drawing;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->internal_drawing = [[ICMDrawing alloc] init];
    }
    
    return self;
}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError {
    return YES;
}
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outError {
    return YES;
}

- (void)makeWindowControllers {
    ICAKDrawingController* dc = [[ICAKDrawingController alloc] init];
    [dc setDocument:self];
    [self addWindowController:dc];
}

- (ICMDrawing*)drawing {
    return self->internal_drawing;
}

@end