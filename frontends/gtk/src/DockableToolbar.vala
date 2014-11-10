class icCanvasGtk.DockableToolbar : Gtk.Bin, Gtk.Orientable, icCanvasGtk.Dockable {
    public icCanvasGtk.DockingStyle docking_style {
        get {
            return icCanvasGtk.DockingStyle.TOOLBAR;
        } set {
            //Does nothing
        }
    }
    
    private Gtk.Widget? _child;
    private Gdk.Window? _evtwnd;
    private Gtk.Allocation _handle_alloc;
    
    public DockableToolbar() {
        this.add_events(Gdk.EventMask.POINTER_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK | Gdk.EventMask.LEAVE_NOTIFY_MASK);
        this.set_has_window(true);
        this._evtwnd = null;
        this._child = null;
        this._handle_alloc = Gtk.Allocation();
    }
    
    private Gtk.Orientation _orientation;
    
    public Gtk.Orientation orientation {
        get {
            return this._orientation;
        }
        set {
            this._orientation = value;
            
            if (this._child != null && this._child is Gtk.Orientable) {
                (this._child as Gtk.Orientable).orientation = value;
            }
        }
    }
    
    public override Gtk.SizeRequestMode get_request_mode () {
        if (this._child != null) {
            return this._child.get_request_mode ();
        } else if (this.orientation == Gtk.Orientation.VERTICAL) {
            return Gtk.SizeRequestMode.HEIGHT_FOR_WIDTH;
        }
        
        //this.orientation == Gtk.Orientation.HORIZONTAL
        return Gtk.SizeRequestMode.WIDTH_FOR_HEIGHT;
    }
    
    private const int PADDING_CROSS = 1;
    private const int PADDING_MAIN = 1;
    private const int HANDLE_LENGTH = 10;
    
    //Widget sizing
    public override void get_preferred_width (out int minimum_width, out int natural_width) {
        minimum_width = 0;
        natural_width = 0;
        
        if (this._child != null) {
            this._child.get_preferred_width (out minimum_width, out natural_width);
        }
        
        if (this.orientation == Gtk.Orientation.VERTICAL) {
            minimum_width += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
            natural_width += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        } else if (this.orientation == Gtk.Orientation.HORIZONTAL) {
            minimum_width += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            natural_width += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
        }
    }
    
    public override void get_preferred_height (out int minimum_height, out int natural_height) {
        minimum_height = 0;
        natural_height = 0;
        
        if (this._child != null) {
            this._child.get_preferred_width (out minimum_height, out natural_height);
        }
        
        if (this.orientation == Gtk.Orientation.HORIZONTAL) {
            minimum_height += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
            natural_height += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        } else if (this.orientation == Gtk.Orientation.VERTICAL) {
            minimum_height += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            natural_height += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
        }
    }
    
    public override void get_preferred_width_for_height (int height, out int minimum_width, out int natural_width) {
        var child_height = height;
        minimum_width = 0;
        natural_width = 0;
        
        if (this.orientation == Gtk.Orientation.HORIZONTAL) {
            child_height -= icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        } else if (this.orientation == Gtk.Orientation.VERTICAL) {
            child_height -= icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
        }
        
        this._child.get_preferred_width_for_height (child_height, out minimum_width, out natural_width);
        
        if (this.orientation == Gtk.Orientation.VERTICAL) {
            minimum_width += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
            natural_width += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        } else if (this.orientation == Gtk.Orientation.HORIZONTAL) {
            minimum_width += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            natural_width += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
        }
    }
    
    public override void get_preferred_height_for_width (int width, out int minimum_height, out int natural_height) {
        var child_width = width;
        minimum_height = 0;
        natural_height = 0;
        
        if (this.orientation == Gtk.Orientation.VERTICAL) {
            child_width -= icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        } else if (this.orientation == Gtk.Orientation.HORIZONTAL) {
            child_width -= icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
        }
        
        this._child.get_preferred_width_for_height (child_width, out minimum_height, out natural_height);
        
        if (this.orientation == Gtk.Orientation.HORIZONTAL) {
            minimum_height += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
            natural_height += icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        } else if (this.orientation == Gtk.Orientation.VERTICAL) {
            minimum_height += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            natural_height += icCanvasGtk.DockableToolbar.PADDING_MAIN * 3 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
        }
    }
    
    public override void size_allocate (Gtk.Allocation allocation) {
        this.set_allocation(allocation);
        
        Gtk.Allocation toolbar_alloc = Gtk.Allocation();
        this._handle_alloc = Gtk.Allocation();
        
        if (this.orientation == Gtk.Orientation.HORIZONTAL) {
            toolbar_alloc.x = icCanvasGtk.DockableToolbar.PADDING_MAIN * 2 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            toolbar_alloc.y = icCanvasGtk.DockableToolbar.PADDING_CROSS;
            toolbar_alloc.width = int.max(allocation.width - toolbar_alloc.x - icCanvasGtk.DockableToolbar.PADDING_MAIN, 0);
            toolbar_alloc.height = int.max(allocation.height - icCanvasGtk.DockableToolbar.PADDING_CROSS * 2, 0);
            
            this._handle_alloc.x = icCanvasGtk.DockableToolbar.PADDING_MAIN;
            this._handle_alloc.y = icCanvasGtk.DockableToolbar.PADDING_CROSS;
            this._handle_alloc.width = icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            this._handle_alloc.height = allocation.height - icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        } else if (this.orientation == Gtk.Orientation.VERTICAL) {
            toolbar_alloc.x = icCanvasGtk.DockableToolbar.PADDING_CROSS;
            toolbar_alloc.y = icCanvasGtk.DockableToolbar.PADDING_MAIN * 2 + icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            toolbar_alloc.width = int.max(allocation.width - icCanvasGtk.DockableToolbar.PADDING_CROSS * 2, 0);
            toolbar_alloc.height = int.max(allocation.height - toolbar_alloc.y - icCanvasGtk.DockableToolbar.PADDING_MAIN, 0);
            
            this._handle_alloc.y = icCanvasGtk.DockableToolbar.PADDING_MAIN;
            this._handle_alloc.x = icCanvasGtk.DockableToolbar.PADDING_CROSS;
            this._handle_alloc.height = icCanvasGtk.DockableToolbar.HANDLE_LENGTH;
            this._handle_alloc.width = allocation.width - icCanvasGtk.DockableToolbar.PADDING_CROSS * 2;
        }
        
        if (this._child != null) {
            this._child.size_allocate(toolbar_alloc);
        }
        
        if (this.get_realized()) {
            this._evtwnd.move_resize(allocation.x, allocation.y, allocation.width, allocation.height);
        }
    }
    
    public override void forall_internal (bool include_internals, Gtk.Callback callback) {
        if (this._child != null) {
            callback (this._child);
        }
    }
    
    public override void add (Gtk.Widget widget) {
        if (this._child == null) {
            this._child = widget;
            this._child.set_parent(this);
        }
    }
    
    public override void remove (Gtk.Widget widget) {
        if (this._child == widget) {
            this._child = null;
            this._child.set_parent(null);
        }
    }
    
    //Events
    public override void realize() {
        this.set_realized(true);

        if (this._evtwnd == null) {
            var attributes = Gdk.WindowAttr();
            
            Gtk.Allocation allocation;
            this.get_allocation(out allocation);
            
            attributes.x = allocation.x;
            attributes.y = allocation.y;
            attributes.width = allocation.width;
            attributes.height = allocation.height;
            
            attributes.event_mask = this.get_events() | Gdk.EventMask.EXPOSURE_MASK;
            attributes.window_type = Gdk.WindowType.CHILD;
            attributes.wclass = Gdk.WindowWindowClass.INPUT_OUTPUT;
            
            this._evtwnd = new Gdk.Window(this.get_parent_window(), attributes, Gdk.WindowAttributesType.X | Gdk.WindowAttributesType.Y);
            this._evtwnd.set_cursor(new Gdk.Cursor.for_display(this._evtwnd.get_display(), Gdk.CursorType.ARROW));
            this.set_window(this._evtwnd);

            this._evtwnd.set_user_data(this);
        }
    }
    
    public override void unrealize() {
        this._evtwnd = null;
        base.unrealize();
    }
    
    //Drawing
    public override bool draw (Cairo.Context cr) {
        cr.set_source_rgba(0,0,0,1);
        cr.rectangle(this._handle_alloc.x, this._handle_alloc.y, this._handle_alloc.width, this._handle_alloc.height);
        cr.fill();
        
        base.draw(cr);
        
        return false;
    }
}