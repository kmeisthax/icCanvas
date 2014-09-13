using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    private GLib.List<icCanvasGtk.Drawing> drawing_list;

    public Application (string s, GLib.ApplicationFlags f) {
        
    }
    
    public override void activate() {
        var drawing = new icCanvasGtk.Drawing();
        drawing.make_windows(this);
        this.add_drawing(drawing);
        
        GLib.Idle.add_full(GLib.Priority.DEFAULT_IDLE, this.on_idle);
    }
    
    public bool on_idle() {
        var app = icCanvasManager.Application.get_instance();
        
        app.background_tick();
        
        return true;
    }
    
    public void add_drawing(icCanvasGtk.Drawing drawing) {
        this.drawing_list.append(drawing);
    }
}