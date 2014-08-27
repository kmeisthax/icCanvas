using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    public Application (string s, GLib.ApplicationFlags f) {
        
    }
    
    public override void activate() {
        print("It works\n");
    }
}