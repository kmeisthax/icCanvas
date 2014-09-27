/* A Dock is responsible for managing Dockable widgets which users and program
 * code may place along the margins of a single main widget.
 */
class icCanvasGtk.Dock : Gtk.Box {
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
    
    public icCanvasGtk.Dockable? offered_dockable { get; set; }
    
    private int get_best_edge_box(icCanvasGtk.Dockable dockwdgt, Edge edge) {
        List<Gtk.Widget> owned_tgt = this.get_children();
        unowned List<Gtk.Widget> tgt = owned_tgt;
        Gtk.Widget stop = this._hbox;
        var go_fwd = true;
        var rval = 0;
        
        switch (edge) {
            case Edge.TOP:
                break;
            case Edge.BOTTOM:
                tgt = tgt.last();
                go_fwd = false;
                break;
            case Edge.LEFT:
                owned_tgt = this._hbox.get_children();
                tgt = owned_tgt;
                stop = this._center;
                break;
            case Edge.RIGHT:
                owned_tgt = this._hbox.get_children();
                tgt = owned_tgt.last();
                stop = this._center;
                go_fwd = false;
                break;
        }
        
        while (tgt != null) {
            if (tgt.data is icCanvasGtk.DockingBox) {
                if (((icCanvasGtk.DockingBox)tgt.data).is_dockable_compatible(dockwdgt)) {
                    break;
                }
            } else if (tgt.data == stop) {
                rval = -1;
                break;
            }
            
            if (go_fwd) {
                tgt = tgt.next;
            } else {
                tgt = tgt.prev;
            }
            
            rval++;
        }
        
        return rval;
    }
    
    public void insert_new_row(Edge edge, uint before_row) {
        var new_row = new icCanvasGtk.DockingBox();
        Gtk.Box tgt = this;
        
        if (edge == Edge.LEFT || edge == Edge.RIGHT) {
            tgt = this._hbox;
            new_row.orientation = Gtk.Orientation.VERTICAL;
        } else {
            new_row.orientation = Gtk.Orientation.HORIZONTAL;
        }
        
        if (edge == Edge.BOTTOM || edge == Edge.RIGHT) {
            before_row = tgt.get_children().length() - before_row;
        }
        
        tgt.pack_start(new_row, false, false, 0);
    }
    
    /* Add a dockable widget to a particular edge of the dock.
     */
    public void add_dockable(icCanvasGtk.Dockable dockwdgt, Edge edge) {
        var recommended_offset = get_best_edge_box(dockwdgt, edge);
        if (recommended_offset == -1) {
            this.insert_new_row(edge, 0);
            recommended_offset = 0;
        }
        
        this.add_dockable_positioned(dockwdgt, edge, recommended_offset, 0);
    }
    
    public void add_dockable_positioned(icCanvasGtk.Dockable dockwdgt, Edge edge, uint offsetFromEdge, int pos) {
        icCanvasGtk.DockingBox dockrow;
        Gtk.Box tgt = this;
        
        if (edge == Edge.LEFT || edge == Edge.RIGHT) {
            tgt = this._hbox;
        }
        
        List<Gtk.Widget> owned_list = tgt.get_children();
        unowned List<Gtk.Widget> list = owned_list;
        
        if (edge == Edge.BOTTOM || edge == Edge.RIGHT) {
            offsetFromEdge = owned_list.length() - offsetFromEdge;
        }
        
        list = list.nth(offsetFromEdge);
        dockrow = list.data as icCanvasGtk.DockingBox;
        dockrow.pack_start(dockwdgt as Gtk.Widget, false, false, 0);
        dockrow.reorder_child(dockwdgt as Gtk.Widget, pos);
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