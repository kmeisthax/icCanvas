using icCanvasManager;
using icCanvasGtk;

using GLib;

void main(string[] argv) {
    Gtk.init(ref argv);
    
    icCanvasGtk.Application app = new icCanvasGtk.Application("org.fantranslation.code.icCanvas.gtk", GLib.ApplicationFlags.FLAGS_NONE);
    
    app.run(argv);
}