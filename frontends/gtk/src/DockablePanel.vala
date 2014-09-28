class icCanvasGtk.DockablePanel : Gtk.Bin, Gtk.Orientable, icCanvasGtk.Dockable {
    private Gtk.Widget? _child;
    private Gtk.Label _label;
    
    public DockablePanelTest() {
        this._label = new Gtk.Label("Panel Test");
        this._label.halign = Gtk.Align.START;
        this._label.set_parent(this);
        this._label.show();
    }
    
    public icCanvasGtk.DockingStyle docking_style {
        get {
            return icCanvasGtk.DockingStyle.PANEL;
        }
        set {
            //Do nothing.
        }
    }
    
    public Gtk.Orientation orientation { set; get; }
    
    public override Gtk.SizeRequestMode get_request_mode () {
        if (this._child != null) {
            return this._child.get_request_mode ();
        } else if (this.orientation == Gtk.Orientation.VERTICAL) {
            return Gtk.SizeRequestMode.HEIGHT_FOR_WIDTH;
        }
        
        //this.orientation == Gtk.Orientation.HORIZONTAL
        return Gtk.SizeRequestMode.WIDTH_FOR_HEIGHT;
    }
    
    public override void get_preferred_width (out int minimum_width, out int natural_width) {
        if (this._child != null) {
            this._child.get_preferred_width (out minimum_width, out natural_width);
        } else {
            minimum_width = 240;
            natural_width = 320;
        }
    }
    
    public override void get_preferred_height (out int minimum_height, out int natural_height) {
        if (this._child != null) {
            this._child.get_preferred_height (out minimum_height, out natural_height);
        } else {
            minimum_height = 240;
            natural_height = 320;
        }
    }
    
    public override void get_preferred_width_for_height (int height, out int minimum_width, out int natural_width) {
        if (this._child != null) {
            this._child.get_preferred_width_for_height (height, out minimum_width, out natural_width);
        } else {
            minimum_width = 240;
            natural_width = 320;
        }
    }
    
    public override void get_preferred_height_for_width (int width, out int minimum_height, out int natural_height) {
        if (this._child != null) {
            this._child.get_preferred_height_for_width (width, out minimum_height, out natural_height);
        } else {
            minimum_height = 240;
            natural_height = 320;
        }
    }
    
    public override void size_allocate (Gtk.Allocation allocation) {
        this.set_allocation(allocation);
        
        Gtk.Allocation label_alloc = Gtk.Allocation();
        Gtk.Allocation panel_alloc = Gtk.Allocation();
        int bitbucket;
        
        label_alloc.x = 15;
        label_alloc.y = 15;
        label_alloc.width = int.max(allocation.width - 30, 0);
        this._label.get_preferred_height_for_width(label_alloc.width, out label_alloc.height, out bitbucket);
        label_alloc.height = int.max(label_alloc.height, 15);
        
        panel_alloc.x = label_alloc.x;
        panel_alloc.y = label_alloc.y + label_alloc.height + label_alloc.y;
        panel_alloc.width = label_alloc.width;
        panel_alloc.height = allocation.height - panel_alloc.y - label_alloc.y;
        
        this._label.size_allocate(label_alloc);
        if (this._child != null) {
            this._child.size_allocate(panel_alloc);
        }
    }
    
    public override void forall_internal (bool include_internals, Gtk.Callback callback) {
        if (include_internals) {
            callback (this._label);
        }
        
        if (this._child != null) {
            callback (this._child);
        }
    }
    
    public override void add (Gtk.Widget widget) {
        if (this._child == null) {
            widget.set_parent(this);
            this._child = widget;
        }
    }
    
    public override void remove (Gtk.Widget widget) {
        if (this._child == widget) {
            widget.unparent();
            this._child = null;
            
            if (this.get_visible() && widget.get_visible()) {
                this.queue_resize_no_redraw();
            }
        }
    }
    
    public override bool draw(Cairo.Context cr) {
        this.propagate_draw(this._label, cr);
        
        if (this._child != null) {
            this.propagate_draw(this._child, cr);
        }
        
        return false;
    }
}