class icCanvasGtk.Drawing {
    private GLib.List<icCanvasGtk.DrawingWindow> _windows;
    private icCanvasManager.Drawing _drawing;
    
    public icCanvasManager.Drawing core_drawing {
        get {
            return this._drawing;
        }
    }
    
    public Drawing() {
        GLib.Idle.add_full(GLib.Priority.DEFAULT_IDLE, this.on_idle);
    }
    
    public void make_windows(icCanvasGtk.Application app) {
        var wnd = new icCanvasGtk.DrawingWindow(app);
        this.add_window(wnd);
        
        wnd.drawing = this;
        wnd.show_all();
    }
    
    public bool on_idle() {
        var app = icCanvasManager.Application.get_instance();
        var rsched = app.get_render_scheduler();
        var numreqs = rsched.collect_requests(this._drawing);
        
        if (numreqs > 0) {
            this._windows.foreach((wnd) => {
                wnd.tile_rendered();
            });
        }
        
        return true;
    }
    
    public void add_window(icCanvasGtk.DrawingWindow wnd) {
        this._windows.append(wnd);
    }
}