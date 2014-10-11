interface icCanvasGtk.Dockable : Gtk.Orientable {
    public abstract icCanvasGtk.DockingStyle docking_style { get; set; }
    
    /* Fired when the user has detached the widget from it's parent.
     * 
     * Depending on the situation, the recipient of the signal may arrange for
     * the widget to be reparented to a temporary FloatingPanelDock or not. In
     * either case, the Dockable will proceed to move it's parent GtkWindow in
     * response to drag events.
     */
    public signal void detached();
    
    /* Fired when the user has dragged a detached widget.
     * 
     * Typically this event is fired after the widget has moved it's toplevel
     * container in response to the provided Event.
     */
    public signal void dragged_window(Gdk.EventMotion evt);
    
    /* Fired when the user has released the widget.
     * 
     * Depending on the situation, the recipient of the signal may make the
     * above-mentioned temporary FloatingPanelDock permenant, or reparent the
     * widget into another Dock, etc. In either case, the above-mentioned drag
     * behavior will cease.
     */
    public signal void released();
}

enum icCanvasGtk.DockingStyle {
    PANEL,
    TOOLBAR
}