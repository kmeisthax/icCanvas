using Gtk;
using icCanvasManager;

class icCanvasGtk.Application : Gtk.Application {
    private GLib.List<icCanvasGtk.Drawing> _drawing_list;
    private icCanvasGtk.ToolController _tctrl;
    
    private bool _background_ticks_enabled;
    
    public icCanvasGtk.DockingController docking_ctrl { get; set; }
    
    public Application (string s, GLib.ApplicationFlags f) {
        this._drawing_list = new GLib.List<icCanvasGtk.Drawing>();
        this.docking_ctrl = new icCanvasGtk.DockingController();
        this._tctrl = new icCanvasGtk.ToolController(this.docking_ctrl);
        this._background_ticks_enabled = false;
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
        wnd.add_dockable(this._tctrl.new_tools_toolbar(), icCanvasGtk.Dock.Edge.LEFT);
        
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
        var app = icCanvasManager.Application.get_instance();
        icCanvasManager.ApplicationDelegateHooks hk = icCanvasManager.ApplicationDelegateHooks();
        hk.enable_background_ticks = this.enable_background_ticks;
        hk.disable_background_ticks = this.disable_background_ticks;
        
        icCanvasManager.ApplicationDelegate app_del = icCanvasManager.ApplicationDelegate.construct_custom(hk);
        app.delegate = app_del;
        
        var drawing = this.new_drawing();
        this.new_drawing_window(drawing);
    }
    
    public void enable_background_ticks() {
        if (!this._background_ticks_enabled) {
            this._background_ticks_enabled = true;
            GLib.Idle.add_full(GLib.Priority.DEFAULT_IDLE, this.on_idle);
        }
    }
    
    public void disable_background_ticks() {
        this._background_ticks_enabled = false;
        GLib.Idle.remove_by_data(this);
    }
    
    public bool on_idle() {
        var app = icCanvasManager.Application.get_instance();
        
        app.background_tick();
        
        return this._background_ticks_enabled;
    }
    
    public void add_drawing(icCanvasGtk.Drawing drawing) {
        this._drawing_list.append(drawing);
    }
}