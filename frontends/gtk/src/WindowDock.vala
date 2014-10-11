/* A WindowDock is a Dock implementation that is designed to place Dockables
 * around a central widget.
 */
class icCanvasGtk.WindowDock : Gtk.Box, icCanvasGtk.Dock {
    private Gtk.Box _hbox; //For vertical DockingPorts.
    private Gtk.Widget? _center;
    
    private int _vbox_center; //Position of Hbox within self.
    private int _hbox_center; //Position of Center within Hbox.
    
    public WindowDock() {
        Object(orientation:Gtk.Orientation.VERTICAL, spacing:0);
        this._hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        this._center = null;
        
        this.pack_start(this._hbox, true, true, 0);
        
        this._vbox_center = 0;
        this._hbox_center = 0;
    }
    
    private int get_best_edge_box(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge) {
        List<weak Gtk.Widget> owned_tgt = this.get_children();
        unowned List<weak Gtk.Widget> tgt = owned_tgt;
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
    
    public void insert_new_row(icCanvasGtk.Dock.Edge edge, uint before_row) {
        icCanvasGtk.DockingBox new_row;
        Gtk.Box tgt = this;
        
        if (edge == Edge.LEFT || edge == Edge.RIGHT) {
            new_row = new icCanvasGtk.DockingBox(Gtk.Orientation.VERTICAL);
            tgt = this._hbox;
        } else {
            new_row = new icCanvasGtk.DockingBox(Gtk.Orientation.HORIZONTAL);
        }
        
        if (edge == Edge.BOTTOM || edge == Edge.RIGHT) {
            before_row = tgt.get_children().length() - before_row;
        }
        
        tgt.pack_start(new_row, false, false, 0);
    }
    
    /* Add a dockable widget to a particular edge of the dock.
     */
    public void add_dockable(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge) {
        var recommended_offset = get_best_edge_box(dockwdgt, edge);
        if (recommended_offset == -1) {
            this.insert_new_row(edge, 0);
            recommended_offset = 0;
        }
        
        this.add_dockable_positioned(dockwdgt, edge, recommended_offset, -1);
    }
    
    public void add_dockable_positioned(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge, uint offsetFromEdge, int pos) {
        Gtk.Box tgt = this;
        
        if (edge == Edge.LEFT || edge == Edge.RIGHT) {
            tgt = this._hbox;
        }
        
        List<weak Gtk.Widget> owned_list = tgt.get_children();
        unowned List<weak Gtk.Widget> list = owned_list;
        
        if (edge == Edge.BOTTOM || edge == Edge.RIGHT) {
            offsetFromEdge = owned_list.length() - offsetFromEdge;
        }
        
        list = list.nth(offsetFromEdge);
        if (list.data is icCanvasGtk.DockingBox) {
            var dockrow = list.data as icCanvasGtk.DockingBox;
            dockrow.add(dockwdgt as Gtk.Widget);
            dockrow.reorder_child(dockwdgt as Gtk.Widget, pos);
            
            this.added_dockable(dockwdgt, this, dockrow);
        }
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
    
    /* Iterate over the rows of the dock.
     */
    public void foreach_rows(icCanvasGtk.Dock.RowIteratee i) {
        bool should_continue = true;
        var child_start = this.get_children(); //Owned ref.
        unowned GLib.List<weak Gtk.Widget> children = child_start, child_end = children.last();
        var cur_edge = icCanvasGtk.Dock.Edge.TOP;
        uint cur_idx = 0, cur_delta = 1;
        
        while (should_continue) {
            var the_child = children.data;
            
            if (the_child == this._hbox) {
                var hbchild_start = this._hbox.get_children(); //Owned ref.
                unowned GLib.List<weak Gtk.Widget> hbchildren = hbchild_start, hbchild_end = hbchildren.last();
                
                cur_edge = icCanvasGtk.Dock.Edge.LEFT;
                cur_idx = 0;
                cur_delta = 1;
                
                while (should_continue) {
                    var hb_the_child = hbchildren.data;

                    if (hb_the_child == this._center) {
                        if (hbchildren.next == hbchild_start) {
                            break;
                        }
                        
                        cur_edge = icCanvasGtk.Dock.Edge.RIGHT;
                        cur_idx = hbchildren.next.length() - 1;
                        cur_delta = -1;
                    } else {
                        should_continue = i(cur_edge, cur_idx, hb_the_child as icCanvasGtk.DockingBox);
                    }
                    
                    if (hbchildren == hbchild_end) {
                        break;
                    }
                    
                    hbchildren = hbchildren.next;
                    cur_idx += cur_delta;
                }
                
                if (children == child_end) {
                    break;
                }
                
                cur_edge = icCanvasGtk.Dock.Edge.BOTTOM;
                cur_idx = children.next.length() - 1;
                cur_delta = -1;
            } else {
                should_continue = i(cur_edge, cur_idx, the_child as icCanvasGtk.DockingBox);
            }
            
            if (children == child_end) {
                break;
            }
            
            children = children.next;
            cur_idx += cur_delta;
        }
    }
}