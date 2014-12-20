class icCanvasGtk.DockingController : GLib.Object {
    private GLib.List<icCanvasGtk.Dock> _docks;
    
    private struct DockingData {
        public weak icCanvasGtk.Dockable dockable;
        public weak icCanvasGtk.Dock? dock;
        public weak icCanvasGtk.DockingBox? row;
        
        public bool has_selected_dock;
        public icCanvasGtk.Dock? selected_dock;
        public icCanvasGtk.Dock.Edge selected_edge;
        public int selected_offset;
        public int selected_pos;
    }
    
    private Gee.Map<weak Gtk.Widget, DockingData?> _data;
    private weak Gtk.Window? _active_wnd;
    
    public DockingController() {
        this._data = new Gee.HashMap<weak Gtk.Widget, DockingData?>();
        this._docks = new GLib.List<icCanvasGtk.Dock>();
        this._active_wnd = null;
    }
    
    public void add_panel(icCanvasGtk.FloatingPanelDock panel) {
        this._docks.append(panel);
        panel.added_dockable.connect(this.add_dockable);
    }
    
    public void add_dock(icCanvasGtk.WindowDock dock) {
        this._docks.append(dock);
        dock.added_dockable.connect(this.add_dockable);
        (dock.get_toplevel() as Gtk.Window).set_focus.connect_after(this.focus_was_set);
    }
    
    public void focus_was_set(Gtk.Window wnd, Gtk.Widget? focus) {
        this._active_wnd = wnd;
    }
    
    public void remove_dock(icCanvasGtk.Dock dock) {
        this._docks.remove(dock);
        
        //TODO: Remove child dockables in this dock.
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
        dat.has_selected_dock = false;
        
        this._data.@set(dockable as Gtk.Widget, dat);
        
        this.attach_signals(dockable);
    }
    
    private bool widget_hit_test(Gtk.Widget wdgt, double mouse_x, double mouse_y) {
        return this.rectangle_hit_test(this.widget_abs_rect(wdgt), mouse_x, mouse_y);
    }
    
    private Gdk.Rectangle widget_abs_rect(Gtk.Widget wdgt) {
        int wx, wy, rx, ry;
        Gtk.Window wnd = wdgt.get_toplevel() as Gtk.Window;
        wdgt.translate_coordinates(wnd, 0, 0, out wx, out wy);
        wnd.get_window().get_origin(out rx, out ry);
        
        wx += rx;
        wy += ry;
        
        Gdk.Rectangle rekt = Gdk.Rectangle();
        
        rekt.x = wx;
        rekt.y = wy;
        rekt.width = wdgt.get_allocated_width();
        rekt.height = wdgt.get_allocated_height();
        
        return rekt;
    }
    
    private bool rectangle_hit_test(Gdk.Rectangle rekt, double pt_x, double pt_y) {
        return rekt.x <= pt_x && pt_x <= rekt.x + rekt.width && rekt.y <= pt_y && pt_y <= rekt.y + rekt.height;
    }
    
    private Gdk.Rectangle rectangle_edge(Gdk.Rectangle rekt, icCanvasGtk.Dock.Edge edge, int range) {
        var get_rekt = rekt;
        switch (edge) {
            case icCanvasGtk.Dock.Edge.LEFT:
                get_rekt.width = int.min(range, rekt.width / 2);
                break;
            case icCanvasGtk.Dock.Edge.RIGHT:
                get_rekt.width = int.min(range, rekt.width / 2);
                get_rekt.x = get_rekt.x + rekt.width - get_rekt.width;
                break;
            case icCanvasGtk.Dock.Edge.TOP:
                get_rekt.height = int.min(range, rekt.height / 2);
                break;
            case icCanvasGtk.Dock.Edge.BOTTOM:
                get_rekt.height = int.min(range, rekt.height / 2);
                get_rekt.y = get_rekt.y + rekt.height - get_rekt.height;
                break;
        }
        
        return get_rekt;
    }
    
    private const int EDGE_THRESHOLD = 25;
    
    /* Decide what, if any, of our known docks would be suitable to drop a
     * (possibly floating) Dockable into.
     * 
     * The given out parameter found_it indicates if the other out parameters
     * are valid. If false, the contents of the other four out parameters are
     * undefined.
     * 
     * Assumes that the dock the dockable is currently in is not suitable for
     * docking with.
     */
    private void select_dock_for_dockable(icCanvasGtk.Dockable candidate_dockable, double mouse_x, double mouse_y, out bool out_found_it, out icCanvasGtk.Dock? out_target, out icCanvasGtk.Dock.Edge out_edge, out int out_offsetFromEdge, out int out_pos) {
        DockingData? dat = this._data.@get(candidate_dockable as Gtk.Widget);
        
        bool found_it = false;
        icCanvasGtk.Dock? target = null;
        icCanvasGtk.Dock.Edge edge = icCanvasGtk.Dock.Edge.LEFT;
        int offsetFromEdge = 0;
        int pos = 0;
        
        //I am not too terribly proud of this code.
        this._docks.@foreach((d) => {
            if (!found_it && d != dat.dock) {
                target = d;
                
                //Check the edges of the dock.
                if (d is icCanvasGtk.WindowDock) {
                    var wd = d as icCanvasGtk.WindowDock;
                    var center_rekt = this.widget_abs_rect(wd),
                        test_rekt = this.rectangle_edge(center_rekt, icCanvasGtk.Dock.Edge.LEFT, icCanvasGtk.DockingController.EDGE_THRESHOLD);

                    if (this.rectangle_hit_test(test_rekt, mouse_x, mouse_y)) {
                        edge = icCanvasGtk.Dock.Edge.LEFT;
                        offsetFromEdge = -1;
                        pos = 0;
                        found_it = true;
                        return;
                    }

                    test_rekt = this.rectangle_edge(center_rekt, icCanvasGtk.Dock.Edge.RIGHT, icCanvasGtk.DockingController.EDGE_THRESHOLD);

                    if (this.rectangle_hit_test(test_rekt, mouse_x, mouse_y)) {
                        edge = icCanvasGtk.Dock.Edge.RIGHT;
                        offsetFromEdge = -1;
                        pos = 0;
                        found_it = true;
                        return;
                    }

                    test_rekt = this.rectangle_edge(center_rekt, icCanvasGtk.Dock.Edge.TOP, icCanvasGtk.DockingController.EDGE_THRESHOLD);

                    if (this.rectangle_hit_test(test_rekt, mouse_x, mouse_y)) {
                        edge = icCanvasGtk.Dock.Edge.TOP;
                        offsetFromEdge = -1;
                        pos = 0;
                        found_it = true;
                        return;
                    }

                    test_rekt = this.rectangle_edge(center_rekt, icCanvasGtk.Dock.Edge.BOTTOM, icCanvasGtk.DockingController.EDGE_THRESHOLD);

                    if (this.rectangle_hit_test(test_rekt, mouse_x, mouse_y)) {
                        edge = icCanvasGtk.Dock.Edge.BOTTOM;
                        offsetFromEdge = -1;
                        pos = 0;
                        found_it = true;
                        return;
                    }
                }
                
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
                    
                    return !found_it;
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
    
    private void dragged_window(icCanvasGtk.Dockable src, Gdk.EventMotion evt) {
        DockingData? dat = this._data.@get(src as Gtk.Widget);
        if (dat == null) {
            GLib.warning("DockingController got a message from an unregistered Dockable.");
            return;
        }
        
        this.select_dock_for_dockable(src, evt.x_root, evt.y_root, out dat.has_selected_dock, out dat.selected_dock, out dat.selected_edge, out dat.selected_offset, out dat.selected_pos);
        
        this._data.@set(src as Gtk.Widget, dat);
        
        Gtk.Widget wnd = (src as Gtk.Widget).get_toplevel();
        if (dat.has_selected_dock) {
            wnd.set_opacity(0.4);
        } else {
            wnd.set_opacity(1.0);
        }
    }
    
    private void released(icCanvasGtk.Dockable src) {
        DockingData? dat = this._data.@get(src as Gtk.Widget);
        if (dat == null) {
            GLib.warning("DockingController got a message from an unregistered Dockable.");
            return;
        }
        
        if (dat.has_selected_dock) {
            Gtk.Window? wnd = null;
            icCanvasGtk.Dock old_dock = dat.dock;
            if (dat.dock is Gtk.Window) {
                wnd = dat.dock as Gtk.Window;
            }
            
            src.@ref();
            (src as Gtk.Widget).parent.remove(src as Gtk.Widget);
            dat.selected_dock.add_dockable_positioned(src, dat.selected_edge, dat.selected_offset, dat.selected_pos);
            src.unref();
            
            if (wnd != null) {
                this.remove_dock(old_dock);
                wnd.close();
            }
        } else {
            Gtk.Widget wnd = (src as Gtk.Widget).get_toplevel();
            wnd.set_opacity(1.0);
        }
    }
    
    public void attach_signals(icCanvasGtk.Dockable dockable) {
        dockable.detached.connect(this.detached);
        dockable.dragged_window.connect(this.dragged_window);
        dockable.released.connect(this.released);
    }
    
    /* Resolve the target of a dockable UI widget.
     * 
     * Actions are first resolved on the window the dockable is attached to.
     * If the dockable is not attached to a window, then it resolves to the
     * first focused toplevel window in the docking controller.
     */
    
    public Gtk.Window? action_target_for_dockable(icCanvasGtk.Dockable dockable) {
        DockingData? dat = this._data.@get(dockable as Gtk.Widget);
        
        if (dat.dock != null && dat.dock is icCanvasGtk.WindowDock) {
            return (dat.dock as Gtk.Widget).get_toplevel() as Gtk.Window;
        }
        
        return this._active_wnd;
    }
}