#include <icCanvasManager.hpp>
#import <icCanvasManagerObjC.h>

@implementation ICMTileCache {
    icCanvasManager::RefPtr<icCanvasManager::TileCache> _wrapped;
}

- (id)init {
    self = [super init];

    if (self != nil) {
        self->_wrapped = new icCanvasManager::TileCache();
    }

    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];

    if (self != nil) {
        self->_wrapped = (icCanvasManager::TileCache*)optr;
    }

    return self;
};

- (ICMDisplaySuite*)displaySuite {
    auto* ds = self->_wrapped->display_suite();

    return [[ICMDisplaySuite alloc] initFromWrappedObject:(void*)ds];
};

- (void)setDisplaySuite:(ICMDisplaySuite*)displaysuite {
    auto* ds = (icCanvasManager::DisplaySuite*)[displaysuite getWrappedObject];

    self->_wrapped->set_display_suite(ds);
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
