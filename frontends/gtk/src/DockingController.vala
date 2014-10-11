class icCanvasGtk.DockingController : GLib.Object {
    private GLib.List<icCanvasGtk.Dock> _docks;
    
    private struct DockingData {
        public weak icCanvasGtk.Dockable dockable;
        public weak icCanvasGtk.Dock? dock;
        public weak icCanvasGtk.DockingBox? row;
    }
    
    private Gee.Map<weak Gtk.Widget, DockingData?> _data;
    
    public DockingController() {
        this._data = new Gee.HashMap<weak Gtk.Widget, DockingData?>();
        this._docks = new GLib.List<icCanvasGtk.Dock>();
    }
    
    public void add_panel(icCanvasGtk.FloatingPanelDock panel) {
        this._docks.append(panel);
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
    
    private bool widget_hit_test(Gtk.Widget wdgt, int mouse_x, int mouse_y) {
        int wx, wy, rx, ry, wh, ww;
        Gtk.Window wnd = wdgt.get_toplevel() as Gtk.Window;
        wdgt.translate_coordinates(wnd, 0, 0, out wx, out wy);
        wnd.get_position(out rx, out ry);
        
        wx += rx;
        wy += ry;
        
        wh = wdgt.get_allocated_height();
        ww = wdgt.get_allocated_width();
        
        return wx <= mouse_x && mouse_x <= wx + ww && wy <= mouse_y && mouse_y <= wy + wh;
    }
    
    /* Decide what, if any, of our known docks would be suitable to drop a
     * (possibly floating) Dockable into.
     * 
     * The given out parameter found_it indicates if the other out parameters
     * are valid. If false, the contents of the other four out parameters are
     * undefined.
     */
    private void select_dock_for_dockable(icCanvasGtk.Dockable candidate_dockable, int mouse_x, int mouse_y, out bool out_found_it, out icCanvasGtk.Dock? out_target, out icCanvasGtk.Dock.Edge out_edge, out uint out_offsetFromEdge, out int out_pos) {
        bool found_it = false;
        icCanvasGtk.Dock? target = null;
        icCanvasGtk.Dock.Edge edge = icCanvasGtk.Dock.Edge.LEFT;
        uint offsetFromEdge = 0;
        int pos = 0;
        
        //I am not too terribly proud of this code.
        this._docks.@foreach((d) => {
            if (!found_it) {
                target = d;
                
                d.foreach_rows((nu_edge, rowIndex, row) => {
                    edge = nu_edge;
                    offsetFromEdge = rowIndex;
                    
                    if (row.is_dockable_compatible(candidate_dockable) && this.widget_hit_test(row, mouse_x, mouse_y)) {
                        pos = 0;
                        
                        row.@foreach((wdgt) => {
                            if (!found_it && wdgt is icCanvasGtk.Dockable) {
                                if (this.widget_hit_test(wdgt, mouse_x, mouse_y)) {
                                    found_it = true;
                                } else {
                                    pos += 1;
                                }
                            }
                        });
                    }
                    
                    return found_it;
                });
            }
        });
        
        out_found_it = found_it;
        out_target = target;
        out_edge = edge;
        out_offsetFromEdge = offsetFromEdge;
        out_pos = pos;
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