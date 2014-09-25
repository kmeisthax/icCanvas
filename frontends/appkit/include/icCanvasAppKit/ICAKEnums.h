#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, ICAKDockEdge) {
    ICAKDockEdgeTop,
    ICAKDockEdgeBottom,
    ICAKDockEdgeLeft,
    ICAKDockEdgeRight
};

typedef NS_ENUM(NSInteger, ICAKDockableViewStyle) {
    ICAKDockableViewStyleToolbar,
    ICAKDockableViewStylePanel
};
