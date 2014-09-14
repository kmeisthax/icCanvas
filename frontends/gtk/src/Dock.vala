/* A Dock is responsible for managing Dockable widgets which users and program
 * code may place along the margins of a single main widget.
 */
class icCanvasGtk.Dock : Gtk.Box, icCanvasGtk.DockingPort {
    private Gtk.Box _hbox; //For vertical DockingPorts.
    private Gtk.Widget? _center;
    
    private int _vbox_center; //Position of Hbox within self.
    private int _hbox_center; //Position of Center within Hbox.
    
    public Dock() {
        Object(orientation:Gtk.Orientation.VERTICAL, spacing:0);
        this._hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        this._center = null;
        
        this.pack_start(this._hbox, true, true, 0);
        
        this._vbox_center = 0;
        this._hbox_center = 0;
    }
    
    public enum Edge {
        TOP,
        LEFT,
        RIGHT,
        BOTTOM
    }
    
    /* Add a dockable widget to a particular edge of the dock.
     */
    public void add_dockable(icCanvasGtk.Dockable dockwdgt, Edge edge) {
        
    }
    
    /* Set the center widget.
     */
    public Gtk.Widget center {
        get {
            return this._center;
        }
        set {
            if (this._center != null) {
                this._hbox.remove(this._center);
            }
            
            this._center = value;
            
            this._hbox.pack_end(this._center, true, true, 0);
            this._hbox.reorder_child(this._center, this._hbox_center);
        }
    }
}