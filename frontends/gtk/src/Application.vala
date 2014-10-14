using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    private GLib.List<icCanvasGtk.Drawing> _drawing_list;
    public icCanvasGtk.DockingController docking_ctrl { get; set; }
    
    public Application (string s, GLib.ApplicationFlags f) {
        this._drawing_list = new GLib.List<icCanvasGtk.Drawing>();
        this.docking_ctrl = new icCanvasGtk.DockingController();
    }
    
    public override void activate() {
        var drawing = new icCanvasGtk.Drawing();
        this.add_drawing(drawing);
        
        GLib.Idle.add_full(GLib.Priority.DEFAULT_IDLE, this.on_idle);
        
        drawing.make_windows(this);
    }
    
    public bool on_idle() {
        var app = icCanvasManager.Application.get_instance();
        
        app.background_tick();
        
        return true;
    }
    
    public void add_drawing(icCanvasGtk.Drawing drawing) {
        this._drawing_list.append(drawing);
    }
}