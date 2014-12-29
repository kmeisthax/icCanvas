class icCanvasGtk.DrawingWindow : Gtk.ApplicationWindow {
    private Gtk.ScrolledWindow scrollwdgt;
    private icCanvasGtk.CanvasWidget canvaswdgt;
    private icCanvasGtk.WindowDock dock;
    
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
}