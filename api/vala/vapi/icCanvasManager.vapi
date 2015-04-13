[CCode (cheader_filename = "icCanvasManagerC.h")]
namespace icCanvasManager {
    [CCode (cname = "icm_background_ticks_func")]
    public delegate void BackgroundTicksFunc();
    
    [CCode (cname = "icm_application_delegate_hooks",
            destroy_function = "icm_application_delegate_hooks_destroy",
            has_type_id = false)]
    public struct ApplicationDelegateHooks {
        [CCode (delegate_target_cname = "enable_background_ticks_context")]
        public BackgroundTicksFunc enable_background_ticks;
        [CCode (delegate_target_cname = "disable_background_ticks_context")]
        public BackgroundTicksFunc disable_background_ticks;
    }
    
    [CCode (cname = "icm_application_delegate",
            cprefix = "icm_application_delegate_",
            ref_function = "icm_application_delegate_reference",
            unref_function = "icm_application_delegate_dereference")]
    [Compact]
    public class ApplicationDelegate {
        public static ApplicationDelegate construct_custom(ApplicationDelegateHooks hooks);
        public bool is_custom();
    }
    
    [CCode (cname = "icm_application",
            cprefix = "icm_application_",
            ref_function = "icm_application_reference",
            unref_function = "icm_application_dereference")]
    [Compact]
    public class Application {
        public static Application get_instance();

        public void background_tick();
        public RenderScheduler get_render_scheduler();
        
        public ApplicationDelegate delegate {
            [CCode (cname = "icm_application_get_delegate")] get;
            [CCode (cname = "icm_application_set_delegate")] set;
        }
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
        
        public Cairo.Rectangle bounding_box();
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
        public void set_ui_scale(double ui_scale);
        public void get_size(out double width, out double height, out double ui_scale);
        public void get_maximum_size(out double width, out double height);
        public void get_scale_extents(out double minscale, out double maxscale);
        public void set_scroll_center(double x, double y);
        
        public double zoom {
            [CCode (cname = "icm_canvasview_get_zoom")] get;
            [CCode (cname = "icm_canvasview_set_zoom")] set;
        }
        
        public double highest_zoom();
    }
    
    [CCode (cname = "icm_canvastool",
            cprefix = "icm_canvastool_",
            ref_function = "icm_canvastool_reference",
            unref_function = "icm_canvastool_dereference")]
    [Compact]
    public class CanvasTool {
        public void prepare_for_reuse();
        public void set_size(double width, double height, double ui_scale, double zoom);
        public void set_scroll_center(double x, double y);
        
        public void mouse_down(double x, double y, double deltaX, double deltaY);
        public void mouse_drag(double x, double y, double deltaX, double deltaY);
        public void mouse_up(double x, double y, double deltaX, double deltaY);
    }
    
    [CCode (cname = "icm_captured_stroke_func")]
    public delegate void CapturedStrokeFunc(BrushStroke stroke);
    
    [CCode (cname = "icm_brushtool_delegate_hooks",
            destroy_function = "icm_brushtool_delegate_hooks_destroy",
            has_type_id = false)]
    public struct BrushToolDelegateHooks {
        [CCode (delegate_target_cname = "captured_stroke_context")]
        public CapturedStrokeFunc captured_stroke;
    }
    
    [CCode (cname = "icm_brushtool_delegate",
            cprefix = "icm_brushtool_delegate_",
            ref_function = "icm_brushtool_delegate_reference",
            unref_function = "icm_brushtool_delegate_dereference")]
    [Compact]
    public class BrushToolDelegate {
        public static BrushToolDelegate construct_custom(BrushToolDelegateHooks hooks);
        public bool is_custom();
    }
    
    [CCode (cname = "icm_brushtool",
            cprefix = "icm_brushtool_",
            ref_function = "icm_brushtool_reference",
            unref_function = "icm_brushtool_dereference")]
    [Compact]
    public class BrushTool {
        [CCode (cname = "icm_brushtool_construct")]
        public BrushTool();
        
        public static unowned BrushTool? downcast(CanvasTool up_obj);
        public unowned CanvasTool upcast();
        
        public BrushToolDelegate delegate {
            [CCode (cname = "icm_brushtool_get_delegate")] get;
            [CCode (cname = "icm_brushtool_set_delegate")] set;
        }
    }
    
    [CCode (cname = "icm_changed_scroll_and_zoom_func")]
    public delegate void ChangedScrollAndZoomFunc(double x, double y, double zoom);
    
    [CCode (cname = "icm_zoomtool_delegate_hooks",
            destroy_function = "icm_zoomtool_delegate_hooks_destroy",
            has_type_id = false)]
    public struct ZoomToolDelegateHooks {
        [CCode (delegate_target_cname = "changed_scroll_and_zoom_context")]
        public ChangedScrollAndZoomFunc changed_scroll_and_zoom;
    }
    
    [CCode (cname = "icm_zoomtool_delegate",
            cprefix = "icm_zoomtool_delegate_",
            ref_function = "icm_zoomtool_delegate_reference",
            unref_function = "icm_zoomtool_delegate_dereference")]
    [Compact]
    public class ZoomToolDelegate {
        public static ZoomToolDelegate construct_custom(ZoomToolDelegateHooks hooks);
        public bool is_custom();
    }
    
    [CCode (cname = "icm_zoomtool",
            cprefix = "icm_zoomtool_",
            ref_function = "icm_zoomtool_reference",
            unref_function = "icm_zoomtool_dereference")]
    [Compact]
    public class ZoomTool {
        [CCode (cname = "icm_zoomtool_construct")]
        public ZoomTool();
        
        public static unowned ZoomTool? downcast(ZoomTool up_obj);
        public unowned CanvasTool upcast();
        
        public ZoomToolDelegate delegate {
            [CCode (cname = "icm_zoomtool_get_delegate")] get;
            [CCode (cname = "icm_zoomtool_set_delegate")] set;
        }
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
    
    [CCode (cname = "icm_renderer",
            cprefix = "icm_renderer_",
            ref_function = "icm_renderer_reference",
            unref_function = "icm_renderer_dereference")]
    [Compact]
    public class Renderer {
    }
    
    [CCode (cname = "icm_renderscheduler",
            cprefix = "icm_renderscheduler_",
            ref_function = "icm_renderscheduler_reference",
            unref_function = "icm_renderscheduler_dereference")]
    [Compact]
    public class RenderScheduler {
        [CCode (cname = "icm_renderscheduler_construct")]
        public RenderScheduler(Application app);
        
        public Renderer renderer {
            [CCode (cname = "icm_renderscheduler_renderer")] get;
            [CCode (cname = "icm_renderscheduler_set_renderer")] set;
        }
        
        public void request_tile(Drawing d, int x, int y, int size, int time);
        public void request_tiles(Drawing d, Cairo.Rectangle rect, int size, int time);
        
        public void revoke_request_rect(Drawing d, int x_min, int y_min, int x_max, int y_max, bool is_inverse);
        public void revoke_request_zoom(Drawing d, int zoom_min, int zoom_max, bool is_inverse);
        
        public void background_tick();
        
        public int collect_request(Drawing d, out Cairo.Rectangle tile_rect);
    }
    
    namespace GL {
        [CCode (cname = "intptr_t", has_type_id = false)]
        [SimpleType]
        public struct CONTEXT {}
        
        [CCode (cname = "intptr_t", has_type_id = false)]
        [SimpleType]
        public struct DRAWABLE {}
        
        [CCode (cname = "icm_gl_proc", has_target = false, has_type_id = false)]
        public delegate void Proc();
        
        [CCode (cname = "icm_gl_create_main_context_func", has_type_id = false)]
        public delegate CONTEXT CreateMainContextFunc(int major, int minor);
        [CCode (cname = "icm_gl_create_sub_context_func", has_type_id = false)]
        public delegate CONTEXT CreateSubContextFunc();
        [CCode (cname = "icm_gl_shutdown_sub_context_func", has_type_id = false)]
        public delegate void ShutdownSubContextFunc(CONTEXT ctxt);
        [CCode (cname = "icm_gl_make_current_func", has_type_id = false)]
        public delegate CONTEXT MakeCurrentFunc(CONTEXT ctxt, DRAWABLE draw);
        [CCode (cname = "icm_gl_get_current_func", has_type_id = false)]
        public delegate CONTEXT GetCurrentFunc();
        [CCode (cname = "icm_gl_get_proc_address_func", has_type_id = false)]
        public delegate Proc GetProcAddressFunc(string proc_name);

        [CCode (cname = "icm_gl_contextmanager_hooks",
                destroy_function = "icm_gl_contextmanager_hooks_destroy",
                has_type_id = false)]
        public struct ContextManagerHooks {
            [CCode (delegate_target_cname = "create_main_context_context")]
            public CreateMainContextFunc create_main_context;
            [CCode (delegate_target_cname = "create_sub_context_context")]
            public CreateSubContextFunc create_sub_context;
            [CCode (delegate_target_cname = "shutdown_sub_context_context")]
            public ShutdownSubContextFunc shutdown_sub_context;
            [CCode (delegate_target_cname = "make_current_context")]
            public MakeCurrentFunc make_current;
            [CCode (delegate_target_cname = "get_current_context")]
            public GetCurrentFunc get_current;
            [CCode (delegate_target_cname = "get_proc_address_context")]
            public GetProcAddressFunc get_proc_address;
        }
        
        [CCode (cname = "icm_gl_contextmanager",
                cprefix = "icm_gl_contextmanager_",
                ref_function = "icm_gl_contextmanager_reference",
                unref_function = "icm_gl_contextmanager_dereference")]
        [Compact]
        public class ContextManager {
            public static ContextManager construct_custom(ContextManagerHooks hooks);
        }
        
        [CCode (cname = "icm_gl_renderer",
                cprefix = "icm_gl_renderer_",
                ref_function = "icm_gl_renderer_reference",
                unref_function = "icm_gl_renderer_dereference")]
        [Compact]
        public class Renderer {
            [CCode (cname = "icm_gl_renderer_construct")]
            public Renderer(ContextManager cm, CONTEXT ctxt, DRAWABLE drawable);
            
            public static unowned icCanvasManager.GL.Renderer? downcast(icCanvasManager.Renderer up_obj);
            public unowned icCanvasManager.Renderer upcast();
        }
    }
}