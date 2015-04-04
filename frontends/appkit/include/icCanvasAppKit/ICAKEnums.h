#import <Cocoa/Cocoa.h>

#define M_TAU (M_PI * 2.0f);

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

typedef NS_ENUM(NSInteger, ICAKDockableToolbarBehavior) {
    ICAKDockableToolbarBehaviorPalette,
    ICAKDockableToolbarBehaviorAction,
};

typedef NS_ENUM(NSInteger, ICAKColorPickerViewMode) {
    ICAKColorPickerViewModeLinearHorizontal,
    ICAKColorPickerViewModeLinearVertical,
    ICAKColorPickerViewModeCircular,
};

typedef NS_ENUM(NSInteger, ICAKColorPickerViewChannel) {
    ICAKColorPickerViewChannelNone,
    ICAKColorPickerViewChannelHue,
    ICAKColorPickerViewChannelSaturation,
    ICAKColorPickerViewChannelLightness,
    ICAKColorPickerViewChannelRed,
    ICAKColorPickerViewChannelGreen,
    ICAKColorPickerViewChannelBlue,
    ICAKColorPickerViewChannelAlpha,
};

static const CGFloat ICAKDockableViewPanelMargins = 15.0f;
static const CGFloat ICAKDockableViewPanelLabelHeight = 20.0f;
static const CGFloat ICAKDockableViewPanelLabelMargin = 5.0f;
static const CGFloat ICAKDockableViewMinPanelSize = 240.0f;

static const CGFloat ICAKDockableViewToolbarTopMargin = 5.0f;
static const CGFloat ICAKDockableViewToolbarGripLength = 10.0f;
static const CGFloat ICAKDockableViewToolbarSideMargin = 5.0f;
static const CGFloat ICAKDockableViewToolbarBottomMargin = 5.0f;
static const CGFloat ICAKDockableViewToolbarControlMargin = 3.0f;
static const CGFloat ICAKDockableViewToolbarControlIconSize = 24.0f;
static const CGFloat ICAKDockableViewToolbarControlPadding = 3.0f;
static const CGFloat ICAKDockableViewToolbarControlLength = ICAKDockableViewToolbarControlIconSize + ICAKDockableViewToolbarControlPadding * 2.0f;
static const CGFloat ICAKDockableViewMinToolbarSize = ICAKDockableViewToolbarControlLength + ICAKDockableViewToolbarSideMargin * 2.0f;

static const CGFloat ICAKDockableColorPanelInteriorMargin = 5.0f;
static const CGFloat ICAKColorPickerViewLinearCrossLength = 30.0f;
