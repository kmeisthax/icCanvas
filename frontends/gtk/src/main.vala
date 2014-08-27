using icCanvasManager;
using icCanvasGtk;

using GLib;

void main(string[] argv) {
    Gtk.init(ref argv);
    
    icCanvasGtk.Application app = new icCanvasGtk.Application("org.fantranslation.code.icCanvas.gtk", GLib.ApplicationFlags.FLAGS_NONE);
    
    Gtk.Window wnd = new Gtk.Window();
    wnd.set_default_size(400, 400);
    wnd.show_all();
    
    app.run(argv);
}