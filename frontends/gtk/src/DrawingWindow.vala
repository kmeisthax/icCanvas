class icCanvasGtk.DrawingWindow : Gtk.ApplicationWindow {
    private Gtk.ScrolledWindow scrollwdgt;
    private icCanvasGtk.CanvasWidget canvaswdgt;
    private icCanvasGtk.WindowDock dock;
    
    //Available tools
    private icCanvasManager.BrushTool btool;
    private icCanvasManager.ZoomTool ztool;
    
    public DrawingWindow(icCanvasGtk.Application app) {
        Object(application: app);
        
        this.title = "icCanvas";
        this.window_position = Gtk.WindowPosition.CENTER;
        this.set_default_size(400, 400);
        
        this.dock = new icCanvasGtk.WindowDock();
        this.add(dock);
        
        this.scrollwdgt = new Gtk.ScrolledWindow(null, null);
        this.dock.center = scrollwdgt;
        
        this.canvaswdgt = new icCanvasGtk.CanvasWidget();
        this.scrollwdgt.add(canvaswdgt);
        
        this.btool = new icCanvasManager.BrushTool();
        
        icCanvasManager.BrushToolDelegateHooks hooks = icCanvasManager.BrushToolDelegateHooks();
        hooks.captured_stroke = this.captured_stroke;
        icCanvasManager.BrushToolDelegate btd = icCanvasManager.BrushToolDelegate.construct_custom(hooks);
        
        this.btool.delegate = btd;
        
        this.ztool = new icCanvasManager.ZoomTool();
        
        this.switch_to_brushtool();
    }
    
    public icCanvasGtk.Drawing drawing {
        set {
            this.canvaswdgt.drawing = value.core_drawing;
        }
    }
    
    public icCanvasGtk.DockingController docking_controller {
        set {
            value.add_dock(this.dock);
        }
    }
    
    public void tile_rendered(Cairo.Rectangle where) {
        this.canvaswdgt.queue_draw_by_canvasrect(where);
    }
    
    public void add_dockable(icCanvasGtk.Dockable dk, icCanvasGtk.Dock.Edge edge) {
        this.dock.add_dockable(dk, edge);
    }
    
    /* Tool-switching code */
    public void switch_to_brushtool() {
        this.canvaswdgt.current_tool = btool.upcast();
    }
    
    public void switch_to_zoomtool() {
        this.canvaswdgt.current_tool = ztool.upcast();
    }
    
    /* Various tool impls */
    private void captured_stroke(icCanvasManager.BrushStroke stroke) {
        Cairo.Rectangle bbox = stroke.bounding_box();
        
        this.canvaswdgt.drawing.append_stroke(stroke);
        icCanvasManager.Application.get_instance().get_render_scheduler().request_tiles(
            this.canvaswdgt.drawing,
            bbox,
            (int)this.canvaswdgt.internal.highest_zoom(),
            this.canvaswdgt.drawing.strokes_count());
    }
}