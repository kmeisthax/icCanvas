/* A WindowDock is a Dock implementation that is designed to place Dockables
 * around a central widget.
 */
class icCanvasGtk.WindowDock : Gtk.Box, icCanvasGtk.Dock {
    private Gtk.Box _hbox; //For vertical DockingPorts.
    private Gtk.Widget? _center;
    
    private int _hbox_center; //Position of Center within Hbox.
    
    private struct RowData {
        public Gtk.Widget parent; //Widget which contains entire row structure.
        public icCanvasGtk.DockingBox row; //Widget which manages placement of dockables.
    }
    
    private struct DockableData {
        public icCanvasGtk.Dockable dockable;
        public icCanvasGtk.Dock.Edge edge;
        public uint offsetFromEdge;
    }
    
    private Gee.Map<icCanvasGtk.Dock.Edge, Gee.List<RowData?>> _rows;
    private Gee.Map<Gtk.Widget, DockableData?> _dockables;
    
    private bool _in_remove; //Used to prevent unbounded recursion in signal handlers.
    
    public WindowDock() {
        Object(orientation:Gtk.Orientation.VERTICAL, spacing:0);
        this._hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        this._center = null;
        
        this.pack_start(this._hbox, true, true, 0);
        
        this._hbox_center = 0;
        this._rows = new Gee.HashMap<icCanvasGtk.Dock.Edge, Gee.List<RowData?>>();
        
        this._rows.@set(icCanvasGtk.Dock.Edge.LEFT, new Gee.LinkedList<RowData?>());
        this._rows.@set(icCanvasGtk.Dock.Edge.RIGHT, new Gee.LinkedList<RowData?>());
        this._rows.@set(icCanvasGtk.Dock.Edge.TOP, new Gee.LinkedList<RowData?>());
        this._rows.@set(icCanvasGtk.Dock.Edge.BOTTOM, new Gee.LinkedList<RowData?>());
        
        this._dockables = new Gee.HashMap<Gtk.Widget, DockableData?>();
        
        this._in_remove = false;
    }
    
    private int get_best_edge_box(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge) {
        var rowlist = this._rows.@get(edge);
        var i = rowlist.list_iterator();
        
        while (i.has_next()) {
            i.next();
            var dat = i.@get();
            
            if (dat.row.is_dockable_compatible(dockwdgt)) {
                return i.index();
            }
        }
        
        return -1;
    }
    
    public void insert_new_row(icCanvasGtk.Dock.Edge edge, uint before_row) {
        icCanvasGtk.DockingBox new_row;
        Gtk.Box tgt = this;
        var container_offset = before_row;
        
        if (edge == Edge.LEFT || edge == Edge.RIGHT) {
            new_row = new icCanvasGtk.DockingBox(Gtk.Orientation.VERTICAL);
            tgt = this._hbox;
        } else {
            new_row = new icCanvasGtk.DockingBox(Gtk.Orientation.HORIZONTAL);
        }
        
        if (edge == Edge.BOTTOM || edge == Edge.RIGHT) {
            container_offset = tgt.get_children().length() - before_row;
        }
        
        if (edge == Edge.LEFT) {
            this._hbox_center++;
        }
        
        tgt.pack_start(new_row, false, false, 0);
        tgt.reorder_child(new_row, (int)container_offset);
        new_row.show_all();
        
        RowData? dat = RowData();
        dat.parent = new_row;
        dat.row = new_row;
        
        this._rows.@get(edge).insert((int)before_row, dat);
        
        new_row.remove.connect((wdgt) => {
            DockableData? dock_dat = this._dockables.@get(wdgt);
            if (dat == null) {
                GLib.warning("WindowDock got a remove signal from an unregistered Dockable.");
                return;
            }
            
            RowData? dat2 = this._rows.@get(dock_dat.edge).@get((int)dock_dat.offsetFromEdge);
            if (dat2.row.get_children().length() < 1) {
                this.remove_row(dock_dat.edge, dock_dat.offsetFromEdge);
            }
            
            this._dockables.unset(wdgt, null);
        });
    }
    
    /* Add a dockable widget to a particular edge of the dock.
     */
    public void add_dockable(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge) {
        var recommended_offset = get_best_edge_box(dockwdgt, edge);
        this.add_dockable_positioned(dockwdgt, edge, recommended_offset, -1);
    }
    
    /* Add a dockable widget to a particular position on a row of the dock.
     */
    public void add_dockable_positioned(icCanvasGtk.Dockable dockwdgt, icCanvasGtk.Dock.Edge edge, uint offsetFromEdge, int pos) {
        if (offsetFromEdge == -1) {
            this.insert_new_row(edge, 0);
            offsetFromEdge = 0;
        }
        
        RowData? dat = this._rows.@get(edge).@get((int)offsetFromEdge);
        dat.row.add(dockwdgt as Gtk.Widget);
        dat.row.reorder_child(dockwdgt as Gtk.Widget, pos);
        this.added_dockable(dockwdgt, this, dat.row);
        
        DockableData? dock_dat = DockableData();
        dock_dat.dockable = dockwdgt;
        dock_dat.edge = edge;
        dock_dat.offsetFromEdge = offsetFromEdge;
        this._dockables.@set(dockwdgt as Gtk.Widget, dock_dat);
    }
    
    /* Remove a row from the dock.
     * 
     * If the selected row still contains child dockables, those will also be
     * removed.
     */
    public void remove_row(icCanvasGtk.Dock.Edge edge, uint offsetFromEdge) {
        if (this._in_remove) return;
        this._in_remove = true;
        
        var edgeDat = this._rows.@get(edge);
        RowData? dat = edgeDat.@get((int)offsetFromEdge);
        dat.parent.parent.remove(dat.parent); //WARNING: Recursion (see the dockable remove handlers we added)
        edgeDat.remove_at((int)offsetFromEdge);
        
        var i = this._dockables.map_iterator();
        while (i.has_next()) {
            i.next();
            
            var dockDat = i.get_value();
            
            if (dockDat.edge == edge && dockDat.offsetFromEdge > offsetFromEdge) {
                dockDat.offsetFromEdge -= 1;
            }
            
            i.set_value(dockDat);
        }
        
        this._in_remove = false;
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
            
            this._hbox.pack_start(this._center, true, true, 0);
            this._hbox.reorder_child(this._center, this._hbox_center);
        }
    }
    
    /* Iterate over the rows of the dock.
     */
    public void foreach_rows(icCanvasGtk.Dock.RowIteratee ifunc) {
        bool should_continue = true;
        var i = this._rows.map_iterator();
        
        while (i.has_next() && should_continue) {
            i.next();
            
            var edge = i.get_key();
            var j = i.get_value().list_iterator();
            
            while (j.has_next() && should_continue) {
                j.next();
                
                should_continue = ifunc(edge, j.index(), j.@get().row);
            }
        }
    }
}