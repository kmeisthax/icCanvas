#ifndef __ICCANVASMANAGER_CAPI__ICM_APPLICATION__H__
#define __ICCANVASMANAGER_CAPI__ICM_APPLICATION__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#else
#include <stdbool.h>
#endif

    typedef void *icm_application;

    typedef void *icm_renderscheduler;

    icm_application icm_application_get_instance();

    icm_application icm_application_reference(icm_application wrap);
    int icm_application_dereference(icm_application wrap);

    void icm_application_background_tick(icm_application wrap);
    icm_renderscheduler icm_application_get_render_scheduler(icm_application wrap);
    
    /*Delegates are used to facilitate platform-specific management tasks.
      They may exist on the C++ side or be created by bindings (see below)

      Note that it is technically possible to build a non-reference-counted
      delegate. If this is the case then ref/deref are no-ops and deref returns
      negative 1. */
    typedef void *icm_application_delegate;

    icm_application_delegate icm_application_delegate_reference(icm_application_delegate wrap);
    int icm_application_delegate_dereference(icm_application_delegate wrap);

    /*These functions set the function pointers of delegates.
     *Do NOT call them on delegates that return FALSE from is_custom, or your
     *program will crash.
     *
     *The user_data ptr will be passed on invocation of your delegate. Use it
     *to store necessary state data. The lifetime of the pointed-to data must
     *extend beyond the life of the custom delegate.
     */
    typedef void (*icm_background_ticks_func) (void* user_data);

    typedef struct {
        icm_background_ticks_func enable_background_ticks;
        void* enable_background_ticks_context;
        void (*enable_background_ticks_target_destroy_notify)(void*);
        icm_background_ticks_func disable_background_ticks;
        void* disable_background_ticks_context;
        void (*disable_background_ticks_target_destroy_notify)(void*);
    } icm_application_delegate_hooks;

    /*Custom delegates are used to allow C code to be called from C++ code.*/
    icm_application_delegate icm_application_delegate_construct_custom(icm_application_delegate_hooks* hooks);
    bool icm_application_delegate_is_custom(icm_application_delegate wrap);

#ifdef __cplusplus
}
#endif

#endif
