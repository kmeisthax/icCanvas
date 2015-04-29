#include <X11/Xlib.h>

/* Stupid-ass hack because Vala can't wrap macros right */
Window* ICM_XDefaultRootWindow(Display* disp) {
    return DefaultRootWindow(disp);
}
