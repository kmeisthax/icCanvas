#ifndef __ICCANVASMANAGER_CAPI__ICM_DRAWING__H__
#define __ICCANVASMANAGER_CAPI__ICM_DRAWING__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void* icm_drawing;

    icm_drawing icm_drawing_construct();
    icm_drawing icm_drawing_reference(icm_drawing wrap);
    int icm_drawing_dereference(icm_drawing wrap);

    icm_brushstroke icm_drawing_stroke_at_time(icm_drawing wrap, int time);
    int icm_drawing_strokes_count(icm_drawing wrap);

    void icm_drawing_append_stroke(icm_drawing wrap, icm_brushstroke stroke);

#ifdef __cplusplus
}
#endif

#endif
