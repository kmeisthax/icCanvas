#import <Cocoa/Cocoa.h>
#import <icCanvasManagerObjC.h>

@class ICAKDockingController;

@interface ICAKDrawing : NSDocument

- (id)init;

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError;
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outError;

- (void)backgroundTick;

- (ICMDrawing*)drawing;

- (void)setDockingController:(ICAKDockingController*)dock_ctrl;
- (void)setToolPaletteController:(ICAKToolPaletteController*)tpal_ctrl;

@end
