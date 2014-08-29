using Gtk;
using icCanvasManager;

class icCanvasGtk.CanvasWidget : Gtk.Widget, Gtk.Scrollable {
    private icCanvasManager.CanvasView cv;
    private Gdk.Window evtbox;
    
    private double lastx;
    private double lasty;
    
    public CanvasWidget() {
        this.add_events(Gdk.BUTTON_MOTION_MASK | Gdk.BUTTON_PRESS_MASK | Gdk.BUTTON_RELEASE_MASK);
        this.set_has_window(true);
        this.cv = new icCanvasManager.CanvasView();
        
        this.lastx = 0;
        this.lasty = 0;
    }
}