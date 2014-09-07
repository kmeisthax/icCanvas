using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    private GLib.List<icCanvasGtk.Drawing> drawing_list;

    public Application (string s, GLib.ApplicationFlags f) {
        
    }
    
    public override void activate() {
        var wnd = new icCanvasGtk.DrawingWindow();
        var drawing = new icCanvasGtk.Drawing();
        wnd.drawing = drawing;
        
        this.add_window(wnd);
        this.add_drawing(drawing);
    }
    
    public void add_drawing(icCanvasGtk.Drawing drawing) {
        this.drawing_list.append(drawing);
    }
}