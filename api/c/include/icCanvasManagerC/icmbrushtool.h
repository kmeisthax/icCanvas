#ifndef __ICCANVASMANAGER_CAPI__ICM_BRUSHTOOL__H__
#define __ICCANVASMANAGER_CAPI__ICM_BRUSHTOOL__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#else
#include <stdbool.h>
#endif

    typedef void *icm_brushtool;

    icm_brushtool icm_brushtool_construct();
    int icm_brushtool_reference(icm_brushtool wrap);
    int icm_brushtool_dereference(icm_brushtool wrap);

    /*Downcast and upcast functions for converting between icm_canvastool and
      this class. The downcast function may return NULL if the object passed in
      is not an instance of this class. */
    icm_brushtool icm_brushtool_downcast(icm_canvastool up_obj);
    icm_canvastool icm_brushtool_upcast(icm_brushtool down_obj);

    /*Delegates are used to capture brush strokes.
      They may exist on the C++ side or be created by bindings (see below)

      Note that it is technically possible to build a non-reference-counted
      delegate. If this is the case then ref/deref are no-ops and deref returns
      negative 1. */
    typedef void *icm_brushtool_delegate;

    int icm_brushtool_delegate_reference(icm_brushtool_delegate wrap);
    int icm_brushtool_delegate_dereference(icm_brushtool_delegate wrap);

    /*Custom delegates are used to allow C code to be called from C++ code.*/
    icm_brushtool_delegate icm_brushtool_delegate_construct_custom();
    bool icm_brushtool_delegate_is_custom(icm_brushtool_delegate wrap);

    /*These functions set the function pointers of delegates.
     *Do NOT call them on delegates that return FALSE from is_custom, or your
     *program will crash.
     *
     *The user_data ptr will be passed on invocation of your delegate. Use it
     *to store necessary state data. The lifetime of the pointed-to data must
     *extend beyond the life of the custom delegate.
     */
    typedef void (*icm_brushtool_delegate_captured_stroke_func) (icm_brushstroke stroke, void* user_data);
    void icm_brushtool_delegate_set_custom_captured_stroke_func(icm_brushtool_delegate w, icm_brushtool_delegate_captured_stroke_func func, void* user_data);

    /*Finally, you can set your delegate here.*/
    void icm_brushtool_set_delegate(icm_brushtool wrap, icm_brushtool_delegate del);
    icm_brushtool_delegate icm_brushtool_get_delegate(icm_brushtool wrap);
#ifdef __cplusplus
}
#endif

#endif
