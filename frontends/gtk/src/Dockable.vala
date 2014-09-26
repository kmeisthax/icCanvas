interface icCanvasGtk.Dockable : Gtk.Orientable {
    public abstract icCanvasGtk.DockingStyle docking_style { get; set; }
    
    /* Fired when the dockable wants to detach from it's parent.
     * 
     * Depending on the situation, the recipient of the signal may arrange for
     * the widget to be reparented to a temporary GtkWindow (UTILITY type hint)
     * or not. In either case, the Dockable will proceed to move it's parent
     * GtkWindow in response to drag events.
     */
    public signal void detach();
    
    /* Fired when the dockable is considering attaching to a dock or a loose
     * box. Returning false as the last signal handler causes the dockable to
     * cancel attaching to the panel or dock.
     * 
     * If true, the signal recipient may arrange for the target area to show to
     * the user that it can accept the dockable (e.g. by moving other views out
     * of the way and indicating reserved space).
     * 
     * If false, the dockable must not fire the related attach_to_* signals and
     * the signal handler will not perform any additional UI actions.
     */
    public signal bool should_attach_to_row(icCanvasGtk.DockingBox row);
    public signal bool should_attach_to_dock(icCanvasGtk.Dock dock);
    
    /* Fired when a dockable wants to be attached to a dock or a loose box.
     * 
     * The signal handler should arrange to have the dockable widget placed in
     * the indicated area.
     */
    public signal void attach_to_row(icCanvasGtk.DockingBox row, int offset);
    public signal void attach_to_dock(icCanvasGtk.Dock dock, icCanvasGtk.Dock.Edge edge, int rows_from_edge, int offset);
    
    /* Fired when the dockable cancels the attachment operation. The signal
     * handler should remove any animations or placeholders added by the above
     * should_attach_* signals and, if the dockable was placed inside a new,
     * temporary window, make that window permenant.
     */
    public signal void cancel_attach();
}

enum icCanvasGtk.DockingStyle {
    PANEL,
    TOOLBAR
}