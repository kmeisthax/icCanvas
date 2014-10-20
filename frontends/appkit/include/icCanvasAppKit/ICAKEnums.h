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

static const CGFloat ICAKDockableViewMinPanelSize = 240.0f;
static const CGFloat ICAKDockableViewMinToolbarSize = 50.0f;

static const CGFloat ICAKDockableViewPanelMargins = 15.0f;
