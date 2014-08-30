using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    public Application (string s, GLib.ApplicationFlags f) {
        
    }
    
    public override void activate() {
        var wnd = new Gtk.Window();
        wnd.title = "icCanvas";
        wnd.window_position = Gtk.WindowPosition.CENTER;
        wnd.set_default_size(400, 400);
        
        var cwdgt = new icCanvasGtk.CanvasWidget();
        cwdgt.set_size_request(100, 100);
        wnd.add(cwdgt);
        wnd.show_all();
        
        var doc = new icCanvasManager.Drawing();
        cwdgt.set_drawing(doc);
        
        this.add_window(wnd);
    }
}