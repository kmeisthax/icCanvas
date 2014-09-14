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
class icCanvasGtk.DockingBox : Gtk.Box, Gtk.Orientable, icCanvasGtk.DockingPort {
    public DockingBox() {
        this.add_events(Gdk.EventMask.BUTTON_RELEASE_MASK);
        this.set_has_window(true);
        
        this._evt_window = null;
        
        this._orient = Gtk.Orientation.HORIZONTAL;
        this._current_style = icCanvasGtk.DockingStyle.TOOLBAR;
        this._dockable_count = 0;
        this._mode = icCanvasGtk.DockingPort.PortMode.DISINTERESTED;
        
        this.offered_dockable = null;
        this._parent = null;
        
        this._tracking_port = null;
    }
    
    private Gdk.Window? _evt_window;
    
    private Gtk.Orientation _orient;
    private icCanvasGtk.DockingStyle _current_style;
    private int _dockable_count;
    private GLib.List<weak icCanvasGtk.Dockable> _dockables;
    private icCanvasGtk.DockingPort.PortMode _mode;
    
    private weak icCanvasGtk.DockingPort? _parent;
    private ulong signal_id;
    
    private icCanvasGtk.DockingPort? _tracking_port;
    
    public icCanvasGtk.Dockable? offered_dockable { get; set; }
    
    public icCanvasGtk.DockingPort? parent_port {
        set {
            if (this._parent != null) {
                this._parent.disconnect(this.signal_id);
            }
            
            this._parent = value;
            
            if (this._parent != null) {
                this.signal_id = this._parent.mode_changed.connect(on_mode_did_change);
            }
        }
    }
    
    //PortMode state machine
    private void on_mode_did_change(icCanvasGtk.DockingPort src, icCanvasGtk.DockingPort.PortMode mode) {
        if (src == this) {
            return;
        }
        
        if (mode == PortMode.SENDING) {
            if (this.is_dockable_compatible(src.offered_dockable)) {
                this._mode = PortMode.RECEIVING;
                this._tracking_port = src;
            }
        }
        
        if (mode == PortMode.DISINTERESTED && src == this._tracking_port) {
            this._tracking_port = null;
        }
    }
    
    public bool is_dockable_compatible(icCanvasGtk.Dockable dockable) {
        if (this._dockable_count == 0) {
            return true;
        }
        
        if (dockable.docking_style == this._current_style) {
            return true;
        }
        
        return false;
    }
    
    //Widget takeover
    private void take_widget_from_tracked_port() {
        
    }
    
    public virtual void accept_offer(icCanvasGtk.DockingPort foreign_port) {
        this._mode = PortMode.DISINTERESTED;
        this.mode_changed(this, this._mode);
    }
    
    public Gtk.Orientation orientation {
        get {
            return this._orient;
        }
        set {
            base.orientation = value;
            this._orient = value;
        }
    }
    
    //Low-level event machinery
    public override void realize() {
        this.set_realized(true);

        if (this._evt_window == null) {
            var attributes = Gdk.WindowAttr();
            
            Gtk.Allocation allocation;
            this.get_allocation(out allocation);
            
            attributes.x = allocation.x;
            attributes.y = allocation.y;
            attributes.width = allocation.width;
            attributes.height = allocation.height;
            
            attributes.event_mask = this.get_events();
            attributes.window_type = Gdk.WindowType.CHILD;
            attributes.wclass = Gdk.WindowWindowClass.INPUT_ONLY;
            
            this._evt_window = new Gdk.Window(this.get_parent_window(), attributes, Gdk.WindowAttributesType.X | Gdk.WindowAttributesType.Y);
            this.set_window(this._evt_window);
            
            this._evt_window.set_user_data(this);
        }
    }
    
    public override void unrealize() {
        this._evt_window = null;
        base.unrealize();
    }
    
    public override bool button_release_event(Gdk.EventButton evt) {
        if (this._mode == icCanvasGtk.DockingPort.PortMode.RECEIVING) {
            //Call some function to handle the proper reciept of the widget
            return false;
        }
        
        return true;
    }
}