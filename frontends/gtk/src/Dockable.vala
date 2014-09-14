interface icCanvasGtk.Dockable : Gtk.Orientable {
    public abstract icCanvasGtk.DockingStyle docking_style { get; set; }
    
    public signal void will_detach();
}

enum icCanvasGtk.DockingStyle {
    PANEL,
    TOOLBAR
}