class icCanvasGtk.DockingController : GLib.Object {
    private GLib.List<Gtk.Window> _loose_panels;
    private GLib.List<icCanvasGtk.Dock> _docks;
    
    public void add_panel(Gtk.Window panel) {
        this._loose_panels.append(panel);
    }
    
    public void add_dock(icCanvasGtk.Dock dock) {
        this._docks.append(dock);
    }
    
    private void detach(icCanvasGtk.Dockable src) {
    }
    
    private bool should_attach_to_row(icCanvasGtk.Dockable src, icCanvasGtk.DockingBox row) {
    }
    
    private bool should_attach_to_dock(icCanvasGtk.Dockable src, icCanvasGtk.Dock dock) {
    }
    
    private void attach_to_row(icCanvasGtk.Dockable src, icCanvasGtk.DockingBox row, int offset) {
    }
    
    private void attach_to_dock(icCanvasGtk.Dockable src, icCanvasGtk.Dock dock, icCanvasGtk.Dock.Edge edge, int rows_from_edge, int offset) {
    }
    
    private void cancel_attach(icCanvasGtk.Dockable src) {
    }
    
    public void attach_signals(icCanvasGtk.Dockable dockable) {
        dockable.detach.connect(this.detach);
        dockable.should_attach_to_row.connect(this.should_attach_to_row);
        dockable.should_attach_to_dock.connect(this.should_attach_to_dock);
        dockable.attach_to_row.connect(this.attach_to_row);
        dockable.attach_to_dock.connect(this.attach_to_dock);
        dockable.cancel_attach.connect(this.cancel_attach);
    }
}