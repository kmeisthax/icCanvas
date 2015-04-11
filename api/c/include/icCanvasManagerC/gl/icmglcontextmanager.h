#ifndef __ICCANVASMANAGER_CAPI__ICM_GL_CONTEXTMANAGER__H__
#define __ICCANVASMANAGER_CAPI__ICM_GL_CONTEXTMANAGER__H__

#include <icCanvasManagerC.h>

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_gl_contextmanager;

    icm_gl_contextmanager icm_gl_contextmanager_reference(icm_gl_contextmanager wrap);
    int icm_gl_contextmanager_dereference(icm_gl_contextmanager wrap);

    typedef void (*icm_gl_proc)();

    typedef intptr_t (*icm_gl_create_main_context_func)(int major, int minor, void* user_data);
    typedef intptr_t (*icm_gl_create_sub_context_func)(void* user_data);
    typedef void (*icm_gl_shutdown_sub_context_func)(intptr_t ctxt, void* user_data);
    typedef intptr_t (*icm_gl_make_current_func)(intptr_t ctxt, intptr_t drawable, void* user_data);
    typedef intptr_t (*icm_gl_get_current_func)(void* user_data);
    typedef icm_gl_proc (*icm_gl_get_proc_address_func)(char* proc_name, void* user_data);

    typedef struct {
        icm_gl_create_main_context_func create_main_context;
        void* create_main_context_context;
        void (*create_main_context_target_destroy_notify)(void*);
        icm_gl_create_sub_context_func create_sub_context;
        void* create_sub_context_context;
        void (*create_sub_context_target_destroy_notify)(void*);
        icm_gl_shutdown_sub_context_func shutdown_sub_context;
        void* shutdown_sub_context_context;
        void (*shutdown_sub_context_target_destroy_notify)(void*);
        icm_gl_make_current_func make_current;
        void* make_current_context;
        void (*make_current_target_destroy_notify)(void*);
        icm_gl_get_current_func get_current;
        void* get_current_context;
        void (*get_current_target_destroy_notify)(void*);
        icm_gl_get_proc_address_func get_proc_address;
        void* get_proc_address_context;
        void (*get_proc_address_target_destroy_notify)(void*);
    } icm_gl_contextmanager_hooks;

    icm_gl_contextmanager icm_gl_contextmanager_construct_custom(icm_gl_contextmanager_hooks *hookslist);

#ifdef __cplusplus
}
#endif

#endif
