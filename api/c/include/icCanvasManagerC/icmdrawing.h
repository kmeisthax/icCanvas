#ifndef __ICCANVASMANAGER_CAPI__ICM_DRAWING__H__
#define __ICCANVASMANAGER_CAPI__ICM_DRAWING__H__

#include <icCanvasManagerC.h>

#ifdef __cplusplus
extern "C" {
#endif

    typedef void *icm_drawing;

    icm_drawing* icm_drawing_construct();
    int icm_drawing_reference(icm_drawing *this);
    int icm_drawing_dereference(icm_drawing *this);

    icm_brushstroke* icm_drawing_stroke_at_time(icm_drawing *this, int time);
    int icm_drawing_strokes_count(icm_drawing *this);

    void icm_drawing_append_stroke(icm_drawing *this, icm_brushstroke *stroke);
    icm_tilecache* icm_drawing_get_tilecache(icm_drawing *this);

#ifdef __cplusplus
}
#endif

#endif
