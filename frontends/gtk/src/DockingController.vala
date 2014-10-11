class icCanvasGtk.DockingController : GLib.Object {
    private GLib.List<icCanvasGtk.FloatingPanelDock> _loose_panels;
    private GLib.List<icCanvasGtk.WindowDock> _docks;
    
    private struct DockingData {
        public weak icCanvasGtk.Dockable dockable;
        public weak icCanvasGtk.Dock? dock;
        public weak icCanvasGtk.DockingBox? row;
    }
    
    private Gee.Map<weak Gtk.Widget, DockingData?> _data;
    
    public DockingController() {
        this._data = new Gee.HashMap<weak Gtk.Widget, DockingData?>();
        this._loose_panels = new GLib.List<icCanvasGtk.FloatingPanelDock>();
        this._docks = new GLib.List<icCanvasGtk.WindowDock>();
    }
    
    public void add_panel(icCanvasGtk.FloatingPanelDock panel) {
        this._loose_panels.append(panel);
        panel.added_dockable.connect(this.add_dockable);
    }
    
    public void add_dock(icCanvasGtk.WindowDock dock) {
        this._docks.append(dock);
        dock.added_dockable.connect(this.add_dockable);
    }
    
    public void add_dockable(icCanvasGtk.Dockable dockable, icCanvasGtk.Dock? dock, icCanvasGtk.DockingBox? row) {
        DockingData? dat;
        if (this._data.has_key(dockable as Gtk.Widget)) {
            dat = this._data.@get(dockable as Gtk.Widget);
        } else {
            dat = DockingData();
        }
        
        dat.dockable = dockable;
        dat.dock = dock;
        dat.row = row;
        
        this._data.@set(dockable as Gtk.Widget, dat);
        
        this.attach_signals(dockable);
    }
    
    private void detached(icCanvasGtk.Dockable src) {
        DockingData? dat = this._data.@get(src as Gtk.Widget);
        if (dat == null) {
            GLib.warning("DockingController got a message from an unregistered Dockable.");
            return;
        }
        
        if (dat.dock is icCanvasGtk.WindowDock ||
           (dat.dock is icCanvasGtk.FloatingPanelDock &&
            dat.row.get_children().length() > 1)) {
            
            //Detaching time
            int wx, wy, rx, ry;
            Gtk.Window wnd = (src as Gtk.Widget).get_toplevel() as Gtk.Window;
            (src as Gtk.Widget).translate_coordinates(wnd, 0, 0, out wx, out wy);
            wnd.get_position(out rx, out ry);
            
            wx += rx;
            wy += ry;
            
            icCanvasGtk.FloatingPanelDock flPanel = new icCanvasGtk.FloatingPanelDock();
            flPanel.set_position(Gtk.WindowPosition.MOUSE);
            flPanel.set_opacity(0.4);
            this.add_panel(flPanel);
            
            src.@ref();
            dat.row.remove(src as Gtk.Widget);
            flPanel.add_dockable(src, icCanvasGtk.Dock.Edge.LEFT);
            src.unref();
            
            flPanel.show_all();
            flPanel.move(wx, wy);
        }
    }
    
    private void dragged_window(Gdk.EventMotion evt) {
        //TODO: Select & indicate drop targets for user
    }
    
    private void released(icCanvasGtk.Dockable src) {
        DockingData? dat = this._data.@get(src as Gtk.Widget);
        if (dat == null) {
            GLib.warning("DockingController got a message from an unregistered Dockable.");
            return;
        }
        
        Gtk.Widget wnd = (src as Gtk.Widget).get_toplevel();
        wnd.set_opacity(1.0);
    }
    
    public void attach_signals(icCanvasGtk.Dockable dockable) {
        dockable.detached.connect(this.detached);
        dockable.dragged_window.connect(this.dragged_window);
        dockable.released.connect(this.released);
    }
}