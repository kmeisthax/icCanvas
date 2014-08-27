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
        wnd.show_all();
        
        this.add_window(wnd);
    }
}