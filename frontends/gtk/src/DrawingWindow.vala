class icCanvasGtk.DrawingWindow : Gtk.ApplicationWindow {
    private Gtk.ScrolledWindow scrollwdgt;
    private icCanvasGtk.CanvasWidget canvaswdgt;
    
    public DrawingWindow() {
        this.title = "icCanvas";
        this.window_position = Gtk.WindowPosition.CENTER;
        this.set_default_size(400, 400);
        
        this.scrollwdgt = new Gtk.ScrolledWindow(null, null);
        this.add(scrollwdgt);
        
        this.canvaswdgt = new icCanvasGtk.CanvasWidget();
        this.scrollwdgt.add(canvaswdgt);
        
        this.show_all();
    }
    
    public icCanvasGtk.Drawing drawing {
        set {
            this.canvaswdgt.drawing = value.core_drawing;
        }
    }
    
    public void tile_rendered() {
        this.canvaswdgt.queue_draw();
    }
}