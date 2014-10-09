/* A FloatingPanelDock manages Panel type dockables in a custom window. */
class icCanvasGtk.FloatingPanelDock : Gtk.Window, icCanvasGtk.Dock {
    private icCanvasGtk.DockingBox _wdgt_box;
    
    public FloatingPanelDock() {
        this.title = "";
        this.set_type_hint(Gdk.WindowTypeHint.TOOLBAR);
        
        this._wdgt_box = new icCanvasGtk.DockingBox(Gtk.Orientation.VERTICAL);
        this.add(this._wdgt_box);
    }
    
    /* Does nothing, since this Dock does not have configurable rows.
     */
    public void insert_new_row(icCanvasGtk.Dock.Edge edge, uint before_row) {
    }
    
    /* Copied to match the Dock interface.
     * Edge and offsetFromEdge are not used as FloatingPanel only stores one row
     * of dockables.
     */
    public void add_dockable(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge) {
        this.add_dockable_positioned(dockwdgt, edge, 0, -1);
    }
    
    public void add_dockable_positioned(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge, uint offsetFromEdge, int pos) {
        this._wdgt_box.add(dockwdgt as Gtk.Widget);
        this._wdgt_box.reorder_child(dockwdgt as Gtk.Widget, pos);
        this.added_dockable(dockwdgt, this as icCanvasGtk.Dock, this._wdgt_box);
    }
}