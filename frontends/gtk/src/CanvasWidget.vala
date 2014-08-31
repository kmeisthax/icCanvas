class icCanvasGtk.CanvasWidget : Gtk.Widget, Gtk.Scrollable {
    private icCanvasManager.CanvasView cv;
    private Gdk.Window? evtWindow;
    
    private double lastx;
    private double lasty;
    
    public CanvasWidget() {
        this.add_events(Gdk.EventMask.BUTTON_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK);
        this.set_has_window(true);
        this.cv = new icCanvasManager.CanvasView();
        this.evtWindow = null;
        
        this.lastx = 0;
        this.lasty = 0;
    }
    
    public void set_drawing(icCanvasManager.Drawing d) {
        this.cv.attach_drawing(d);
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
        if (this.get_realized()) {
            this.evtWindow.move_resize(allocation.x, allocation.y, allocation.width, allocation.height);
            this.cv.set_size(allocation.width, allocation.height, this.get_scale_factor());
        }
    }
    
    public override void unrealize() {
        this.set_realized(false);
        this.evtWindow = null;
    }
    
    public override bool draw(Cairo.Context cr) {
        this.cv.draw(cr, cr.copy_clip_rectangle_list());
        
        return true;
    }
    
    public override bool button_press_event(Gdk.EventButton evt) {
        if (evt.type == Gdk.EventType.BUTTON_PRESS) {
            this.cv.mouse_down(evt.x, evt.y, 0, 0);
            
            this.lastx = evt.x;
            this.lasty = evt.y;
        }
        
        return true;
    }
    
    public override bool motion_notify_event(Gdk.EventMotion evt) {
        this.cv.mouse_drag(evt.x, evt.y, evt.x - this.lastx, evt.y - this.lasty);
        
        this.lastx = evt.x;
        this.lasty = evt.y;
        
        return true;
    }
    
    public override bool button_release_event(Gdk.EventButton evt) {
        if (evt.type == Gdk.EventType.BUTTON_RELEASE) {
            this.cv.mouse_up(evt.x, evt.y, evt.x - this.lastx, evt.y - this.lasty);

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
        adjust.lower = 0;
        adjust.value = size / 2.0;
        adjust.upper = size;
        
        adjust.page_increment = 1;
        adjust.page_size = 1;
        adjust.step_increment = 1;
        
        adjust.value_changed.connect(this.update_adjustments);
    }
    
    private void update_adjustments() {
        double hval = 0, vval = 0;
        
        if (_hadjust != null) {
            hval = _hadjust.value;
            
            if (this._hadjust.value + this._hadjust.page_size > this._hadjust.upper) {
                this._hadjust.value = this._hadjust.upper - this._hadjust.page_size;
            }
        }
        
        if (_vadjust != null) {
            vval = _vadjust.value;
            
            if (this._vadjust.value + this._vadjust.page_size > this._vadjust.upper) {
                this._vadjust.value = this._vadjust.upper - this._vadjust.page_size;
            }
        }
        
        this.cv.set_scroll_center(hval, vval);
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
}