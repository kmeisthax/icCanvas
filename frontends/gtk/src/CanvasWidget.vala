class icCanvasGtk.CanvasWidget : Gtk.Widget, Gtk.Scrollable {
    private icCanvasManager.CanvasView cv;
    private icCanvasManager.CanvasTool ct;
    private Gdk.Window? evtWindow;
    
    private double lastx;
    private double lasty;
    
    private weak icCanvasManager.Drawing? _drawing;
    
    public CanvasWidget() {
        this.add_events(Gdk.EventMask.BUTTON_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK);
        this.set_has_window(true);
        this.cv = new icCanvasManager.CanvasView();
        this.evtWindow = null;
        
        this.lastx = 0;
        this.lasty = 0;
        this._drawing = null;
    }
    
    public icCanvasManager.Drawing drawing {
        get {
            return this._drawing;
        }
        
        set {
            this._drawing = value;
            this.cv.attach_drawing(value);
        }
    }
    
    public icCanvasManager.CanvasView internal {
        get {
            return this.cv;
        }
    }
    
    public override void realize() {
        this.set_realized(true);
        
        if (this.evtWindow == null) {
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
            
            this.evtWindow = new Gdk.Window(this.get_parent_window(), attributes, Gdk.WindowAttributesType.X | Gdk.WindowAttributesType.Y);
            this.set_window(this.evtWindow);

            this.evtWindow.set_user_data(this);
        }
    }
    
    public override void size_allocate(Gtk.Allocation allocation) {
        base.size_allocate(allocation);
        
        if (this.get_realized()) {
            this.evtWindow.move_resize(allocation.x, allocation.y, allocation.width, allocation.height);
            this.cv.set_size(allocation.width, allocation.height, this.get_scale_factor());
            this.ct.set_size(allocation.width, allocation.height, this.get_scale_factor(), 65536);
        }
    }
    
    public override void unrealize() {
        this.evtWindow = null;
        base.unrealize();
    }
    
    public override bool draw(Cairo.Context cr) {
        this.cv.draw(cr, cr.copy_clip_rectangle_list());
        
        return true;
    }
    
    public override bool button_press_event(Gdk.EventButton evt) {
        if (evt.type == Gdk.EventType.BUTTON_PRESS) {
            this.ct.mouse_down(evt.x, evt.y, 0, 0);
            
            this.lastx = evt.x;
            this.lasty = evt.y;
        }
        
        return true;
    }
    
    public override bool motion_notify_event(Gdk.EventMotion evt) {
        this.ct.mouse_drag(evt.x, evt.y, evt.x - this.lastx, evt.y - this.lasty);
        
        this.lastx = evt.x;
        this.lasty = evt.y;
        
        return true;
    }
    
    public override bool button_release_event(Gdk.EventButton evt) {
        if (evt.type == Gdk.EventType.BUTTON_RELEASE) {
            this.ct.mouse_up(evt.x, evt.y, evt.x - this.lastx, evt.y - this.lasty);

            this.lastx = evt.x;
            this.lasty = evt.y;

            this.queue_draw();
        }

        return true;
    }
    
    /* Scrollability */
    private Gtk.Adjustment _hadjust;
    private Gtk.Adjustment _vadjust;
    
    private void configure_adjustment(Gtk.Adjustment adjust, double size) {
        adjust.lower = size / -2.0;
        adjust.value = 0;
        adjust.upper = size / 2.0;
        
        adjust.page_increment = 1;
        adjust.page_size = 1;
        adjust.step_increment = this.cv.zoom;
        
        adjust.value_changed.connect(this.update_adjustments);
    }
    
    private void update_adjustments() {
        double hval = 0, vval = 0;
        
        if (_hadjust != null) {
            if (this._hadjust.value + this._hadjust.page_size > this._hadjust.upper) {
                this._hadjust.value = this._hadjust.upper - this._hadjust.page_size;
            }
            
            hval = _hadjust.value;
        }
        
        if (_vadjust != null) {
            if (this._vadjust.value + this._vadjust.page_size > this._vadjust.upper) {
                this._vadjust.value = this._vadjust.upper - this._vadjust.page_size;
            }
            
            vval = _vadjust.value;
        }
        
        this.cv.set_scroll_center(hval, vval);
        this.ct.set_scroll_center(hval, vval);
        
        this.queue_draw();
    }
    
    public Gtk.Adjustment hadjustment {
        get { return this._hadjust; }
        set {
            if (this._hadjust != null) {
                this._hadjust.value_changed.disconnect(this.update_adjustments);
            }
            
            double width;
            this.cv.get_maximum_size(out width, null);
            this.configure_adjustment(value, width);
            
            this._hadjust = value;
        }
    }
    
    public Gtk.Adjustment vadjustment {
        get { return this._vadjust; }
        set {
            if (this._vadjust != null) {
                this._vadjust.value_changed.disconnect(this.update_adjustments);
            }
            
            double height;
            this.cv.get_maximum_size(null, out height);
            this.configure_adjustment(value, height);
            
            this._vadjust = value;
        }
    }
    
    public Gtk.ScrollablePolicy hscroll_policy { get; set; }
    public Gtk.ScrollablePolicy vscroll_policy { get; set; }
    
    /* Redrawing */
    public void queue_draw_by_canvasrect(Cairo.Rectangle canvas_rect) {
        Cairo.Rectangle widget_rect = Cairo.Rectangle();
        Gtk.Allocation widget_alloc;
        
        this.get_allocation(out widget_alloc);
        
        double widget_x = this._vadjust.value - (widget_alloc.width / 2.0);
        double widget_y = this._hadjust.value - (widget_alloc.height / 2.0);
        
        widget_rect.x = (canvas_rect.x - widget_x * this.cv.zoom) / this.cv.zoom;
        widget_rect.y = (canvas_rect.y - widget_y * this.cv.zoom) / this.cv.zoom;
        widget_rect.width = canvas_rect.width / this.cv.zoom;
        widget_rect.height = canvas_rect.height / this.cv.zoom;
        
        this.queue_draw_area((int)widget_rect.x, (int)widget_rect.y, (int)widget_rect.width, (int)widget_rect.height);
    }
    
    public void revoke_widget_rect(bool outside) {
        Cairo.Rectangle canvas_rect = Cairo.Rectangle();
        Gtk.Allocation widget_alloc;
        this.get_allocation(out widget_alloc);
        
        double widget_x = this._vadjust.value - (widget_alloc.width / 2.0);
        double widget_y = this._hadjust.value - (widget_alloc.height / 2.0);
        
        canvas_rect.x = widget_x * this.cv.zoom;
        canvas_rect.y = widget_y * this.cv.zoom;
        canvas_rect.width = widget_alloc.width * this.cv.zoom;
        canvas_rect.height = widget_alloc.height * this.cv.zoom;
    }
    
    /* Swapping tools */
    public icCanvasManager.CanvasTool current_tool {
        get {
            return this.ct;
        }
        
        set {
            this.ct = value;
            this.ct.prepare_for_reuse();
            
            Gtk.Allocation al;
            this.get_allocation(out al);
            
            this.ct.set_size(al.width, al.height, this.get_scale_factor(), 65536);
            this.update_adjustments();
        }
    }
}