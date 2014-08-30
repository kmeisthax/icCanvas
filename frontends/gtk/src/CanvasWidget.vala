using Gtk;
using icCanvasManager;

class icCanvasGtk.CanvasWidget : Gtk.Widget, Gtk.Scrollable {
    private icCanvasManager.CanvasView cv;
    private Gdk.Window? evtWindow;
    
    private double lastx;
    private double lasty;
    
    public CanvasWidget() {
        this.add_events(Gdk.EventMask.BUTTON_MOTION_MASK | Gdk.EventMask.BUTTON_PRESS_MASK | Gdk.EventMask.BUTTON_RELEASE_MASK);
        this.set_has_window(true);
        this.cv = new icCanvasManager.CanvasView();
        
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
}