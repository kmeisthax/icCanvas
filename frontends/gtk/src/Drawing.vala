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
        
        this._drawing = new icCanvasManager.Drawing();
    }
    
    public bool on_idle() {
        var app = icCanvasManager.Application.get_instance();
        var rsched = app.get_render_scheduler();
        Cairo.Rectangle rect;
        var numreqs = rsched.collect_request(this._drawing, out rect);
        
        while (numreqs > 0) {
            this._windows.foreach((wnd) => {
                wnd.tile_rendered(rect);
            });
            
            numreqs = rsched.collect_request(this._drawing, out rect);
        }
        
        return true;
    }
    
    public void add_window(icCanvasGtk.DrawingWindow wnd) {
        this._windows.append(wnd);
    }
}