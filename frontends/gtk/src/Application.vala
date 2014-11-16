using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    private GLib.List<icCanvasGtk.Drawing> _drawing_list;
    public icCanvasGtk.DockingController docking_ctrl { get; set; }
    
    public Application (string s, GLib.ApplicationFlags f) {
        this._drawing_list = new GLib.List<icCanvasGtk.Drawing>();
        this.docking_ctrl = new icCanvasGtk.DockingController();
    }
    
    public icCanvasGtk.Drawing new_drawing() {
        var drawing = new icCanvasGtk.Drawing();
        this.add_drawing(drawing);
        
        return drawing;
    }
    
    public icCanvasGtk.DrawingWindow new_drawing_window(icCanvasGtk.Drawing drawing) {
        var wnd = new icCanvasGtk.DrawingWindow(this);
        
        drawing.add_window(wnd);
        wnd.drawing = drawing;
        
        wnd.docking_controller = this.docking_ctrl;
        wnd.add_dockable(this.new_file_toolbar(), icCanvasGtk.Dock.Edge.TOP);
        
        wnd.show_all();
        
        return wnd;
    }
    
    public icCanvasGtk.Dockable new_file_toolbar() {
        icCanvasGtk.DockableToolbar db = new icCanvasGtk.DockableToolbar();
        Gtk.Toolbar tb = new Gtk.Toolbar();
        
        Gtk.Image tb_newimg = new Gtk.Image.from_icon_name("document-new", Gtk.IconSize.SMALL_TOOLBAR);
        Gtk.ToolButton tb_new = new Gtk.ToolButton(tb_newimg, null);
        tb.add(tb_new);
        
        Gtk.Image tb_openimg = new Gtk.Image.from_icon_name("document-open", Gtk.IconSize.SMALL_TOOLBAR);
        Gtk.ToolButton tb_open = new Gtk.ToolButton(tb_openimg, null);
        tb.add(tb_open);
        db.add(tb);
        
        return db;
    }
    
    public override void activate() {
        GLib.Idle.add_full(GLib.Priority.DEFAULT_IDLE, this.on_idle);
        
        var drawing = this.new_drawing();
        this.new_drawing_window(drawing);
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