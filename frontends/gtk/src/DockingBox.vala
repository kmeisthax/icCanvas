/* A container specifically designed to hold dockable toolbars and panels.
 * 
 * A DockingBox can only hold one type of Dockable at a time - either PANELs
 * or TOOLBARs.
 * 
 * TOOLBARs are limited to a minor length of a single icon and are expected to
 * accept major lengths equal to or shorter than the major length of the Dock.
 * PANELs, on the other hand, have a much wider minor length of at least 320px
 * and may extend beyond the major length of the Dock. The containing Dock is
 * expected to place the DockingBox within a ScrollingWindow.
 */
class icCanvasGtk.DockingBox : Gtk.Box {
    public DockingBox(Gtk.Orientation orient) {
        Object(orientation: orient, spacing: 0);
        
        this._current_style = icCanvasGtk.DockingStyle.TOOLBAR;
        this._dockable_count = 0;
    }
    
    private icCanvasGtk.DockingStyle _current_style;
    private int _dockable_count;
    
    public bool is_dockable_compatible(icCanvasGtk.Dockable dockable) {
        if (this._dockable_count == 0) {
            return true;
        }
        
        if (dockable.docking_style == this._current_style) {
            return true;
        }
        
        return false;
    }
    
    public override void add (Gtk.Widget widget) {
        var dockable = widget as icCanvasGtk.Dockable;
        
        if (dockable != null && is_dockable_compatible(dockable)) {
            base.add(widget);
            
            this._dockable_count++;
            this._current_style = dockable.docking_style;
            
            if (widget is Gtk.Orientable) {
                (widget as Gtk.Orientable).orientation = this.orientation;
            }
        }
    }
    
    public override void remove (Gtk.Widget widget) {
        base.remove(widget);
        this._dockable_count--;
    }
}