using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    public Application (string s, GLib.ApplicationFlags f) {
        
    }
    
    public override void activate() {
        var wnd = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
        wnd.title = "icCanvas";
        wnd.window_position = Gtk.WindowPosition.CENTER;
        wnd.set_default_size(400, 400);
        
        var swnd = new Gtk.ScrolledWindow(null, null);
        wnd.add(swnd);
        
        var cwdgt = new icCanvasGtk.CanvasWidget();
        swnd.add(cwdgt);
        
        wnd.show_all();
        
        var doc = new icCanvasManager.Drawing();
        cwdgt.set_drawing(doc);
        
        this.add_window(wnd);
    }
}