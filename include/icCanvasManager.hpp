#ifndef __ICCANVASMANAGER__H_
#define __ICCANVASMANAGER__H_

#include "icCanvasManager/refcnt.hpp"
#include "icCanvasManager/refptr.hpp"
#include "icCanvasManager/delegator.hpp"
#include "icCanvasManager/rk4integrate.hpp"
#include "icCanvasManager/mvbeizer.hpp"
#include "icCanvasManager/brushstroke.hpp"

#include "icCanvasManager/renderer.hpp"

#include "icCanvasManager/drawing.hpp"
#include "icCanvasManager/splinefitter.hpp"
#include "icCanvasManager/canvasview.hpp"
#include "icCanvasManager/tilecache.hpp"
#include "icCanvasManager/renderscheduler.hpp"
#include "icCanvasManager/singleton.hpp"
#include "icCanvasManager/application.hpp"
#include "icCanvasManager/canvastool.hpp"
#include "icCanvasManager/brushtool.hpp"
#include "icCanvasManager/zoomtool.hpp"
#include "icCanvasManager/displaysuite.hpp"

//Cairo rendering implementations
#include "icCanvasManager/cairo/renderer.hpp"
#include "icCanvasManager/cairo/displaysuite.hpp"

//OpenGL rendering implementations
#include "icCanvasManager/gl/contextmanager.hpp"
#include "icCanvasManager/gl/extensions.hpp"
#include "icCanvasManager/gl/renderer.hpp"
#include "icCanvasManager/gl/displaysuite.hpp"

#endif
