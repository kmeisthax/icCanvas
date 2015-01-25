#ifndef __ICCANVASMANAGER_CAPI__ICM_ZOOMTOOL__H__
#define __ICCANVASMANAGER_CAPI__ICM_ZOOMTOOL__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#else
#include <stdbool.h>
#endif

    typedef void *icm_zoomtool;

    icm_zoomtool icm_zoomtool_construct();
    icm_zoomtool icm_zoomtool_reference(icm_zoomtool wrap);
    int icm_zoomtool_dereference(icm_zoomtool wrap);

    /*Downcast and upcast functions for converting between icm_canvastool and
      this class. The downcast function may return NULL if the object passed in
      is not an instance of this class. */
    icm_zoomtool icm_zoomtool_downcast(icm_canvastool up_obj);
    icm_canvastool icm_zoomtool_upcast(icm_zoomtool down_obj);

    /*Delegates are used to capture zoom operations.
      They may exist on the C++ side or be created by bindings (see below)

      Note that it is technically possible to build a non-reference-counted
      delegate. If this is the case then ref/deref are no-ops and deref returns
      negative 1. */
    typedef void *icm_zoomtool_delegate;

    icm_zoomtool_delegate icm_zoomtool_delegate_reference(icm_zoomtool_delegate wrap);
    int icm_zoomtool_delegate_dereference(icm_zoomtool_delegate wrap);

    /*These functions set the function pointers of delegates.
     *Do NOT call them on delegates that return FALSE from is_custom, or your
     *program will crash.
     *
     *The user_data ptr will be passed on invocation of your delegate. Use it
     *to store necessary state data. The lifetime of the pointed-to data must
     *extend beyond the life of the custom delegate.
     */
    typedef void (*icm_changed_scroll_and_zoom_func) (const double x, const double y, const double zoom, void* user_data);

    typedef struct {
        icm_changed_scroll_and_zoom_func changed_scroll_and_zoom;
        void* changed_scroll_and_zoom_context;
        void (*changed_scroll_and_zoom_target_destroy_notify)(void*);
    } icm_zoomtool_delegate_hooks;

    /*Custom delegates are used to allow C code to be called from C++ code.*/
    icm_zoomtool_delegate icm_zoomtool_delegate_construct_custom(icm_zoomtool_delegate_hooks* hooks);
    bool icm_zoomtool_delegate_is_custom(icm_zoomtool_delegate wrap);

    /*Finally, you can set your delegate here.*/
    void icm_zoomtool_set_delegate(icm_zoomtool wrap, icm_zoomtool_delegate del);
    icm_zoomtool_delegate icm_zoomtool_get_delegate(icm_zoomtool wrap);
#ifdef __cplusplus
}
#endif

#endif
