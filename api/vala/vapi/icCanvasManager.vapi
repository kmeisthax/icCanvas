[CCode (cheader_filename = "icCanvasManagerC.h")]
namespace icCanvasManager {
    [CCode (cname = "icm_application",
            cprefix = "icm_application_",
            ref_function = "icm_application_reference",
            unref_function = "icm_application_dereference")]
    [Compact]
    public class Application {
        public static Application get_instance();

        public void background_tick();
        public RenderScheduler get_render_scheduler();
    }

    [CCode (cname = "icm_brushstroke",
            cprefix = "icm_brushstroke_",
            ref_function = "icm_brushstroke_reference",
            unref_function = "icm_brushstroke_dereference")]
    [Compact]
    public class BrushStroke {
        [CCode (cname = "icm_brushstroke_construct")]
        public BrushStroke();

        public void pen_begin(int32 x, int32 y);

        public void pen_begin_pressure(int32 pressure);
        public void pen_begin_tilt(int32 tilt,
            int32 angle);
        public void pen_begin_velocity(int32 delta_x,
            int32 delta_y);

        public void pen_to(int32 fromcp_x,
            int32 fromcp_y, int32 tocp_x, int32 tocp_y, int32 to_x,
            int32 to_y);
        public void pen_to_pressure(
            int32 fromcp_pressure, int32 tocp_pressure, int32 to_pressure);
        public void pen_to_tilt(int32 fromcp_tilt,
            int32 fromcp_angle, int32 tocp_tilt, int32 tocp_angle,
            int32 to_tilt, int32 to_angle);
        public void pen_to_velocity(
            int32 fromcp_delta_x, int32 fromcp_delta_y, int32 tocp_delta_x,
            int32 tocp_delta_y, int32 to_delta_x, int32 to_delta_y);

        public void pen_extend(int continuity_level);
        public void pen_back();

        public size_t count_segments();
    }
    
    [CCode (cname = "icm_canvasview",
            cprefix = "icm_canvasview_",
            ref_function = "icm_canvasview_reference",
            unref_function = "icm_canvasview_dereference")]
    [Compact]
    public class CanvasView {
        [CCode (cname = "icm_canvasview_construct")]
        public CanvasView();
        
        public void attach_drawing(icCanvasManager.Drawing drawing);
        public void draw(Cairo.Context ctxt, Cairo.RectangleList rectList);
        public void set_size(double width, double height, double ui_scale);
        public void set_size_default(double ui_scale);
        public void get_size(out double width, out double height, out double ui_scale);
        public void get_maximum_size(out double width, out double height);
        public void set_scroll_center(double x, double y);
        public void set_zoom(double vpixel_size);
        
        public void mouse_down(double x, double y, double deltaX, double deltaY);
        public void mouse_drag(double x, double y, double deltaX, double deltaY);
        public void mouse_up(double x, double y, double deltaX, double deltaY);
    }
    
    [CCode (cname = "icm_drawing",
            cprefix = "icm_drawing_",
            ref_function = "icm_drawing_reference",
            unref_function = "icm_drawing_dereference")]
    [Compact]
    public class Drawing {
        [CCode (cname = "icm_drawing_construct")]
        public Drawing();
        
        public BrushStroke stroke_at_time(int time);
        public int strokes_count();
        
        public void append_stroke(BrushStroke stroke);
    }
    
    [CCode (cname = "icm_renderscheduler",
            cprefix = "icm_renderscheduler_",
            ref_function = "icm_renderscheduler_reference",
            unref_function = "icm_renderscheduler_dereference")]
    [Compact]
    public class RenderScheduler {
        [CCode (cname = "icm_renderscheduler_construct")]
        public RenderScheduler();
        
        public void request_tile(Drawing d, int x, int y, int size, int time);
        public void revoke_request(Drawing d, int x_min, int y_min, int x_max, int y_max);
        
        public void background_tick();
        
        public int collect_requests(Drawing d);
    }
}