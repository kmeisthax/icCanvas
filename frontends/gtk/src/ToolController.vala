class icCanvasGtk.ToolController : GLib.Object {
    private icCanvasGtk.DockingController _dctrl;
    
    public ToolController(icCanvasGtk.DockingController dctrl) {
        this._dctrl = dctrl;
    }
    
    public icCanvasGtk.Dockable new_tools_toolbar() {
        icCanvasGtk.DockableToolbar db = new icCanvasGtk.DockableToolbar();
        Gtk.Toolbar tb = new Gtk.Toolbar();
        
        Gtk.Image tb_newimg = new Gtk.Image.from_icon_name("document-new", Gtk.IconSize.SMALL_TOOLBAR);
        Gtk.RadioToolButton tb_brush = new Gtk.RadioToolButton(null);
        tb_brush.clicked.connect(() => {
            Gtk.Window wnd = this._dctrl.action_target_for_dockable(db);
            if (wnd is icCanvasGtk.DrawingWindow) {
                //TODO: Change the tool to BrushTool
            }
        });
        tb_brush.set_icon_widget(tb_newimg);
        tb.add(tb_brush);
        
        Gtk.Image tb_zoomimg = new Gtk.Image.from_icon_name("zoom-in", Gtk.IconSize.SMALL_TOOLBAR);
        Gtk.RadioToolButton tb_zoom = new Gtk.RadioToolButton(tb_brush.get_group());
        tb_zoom.set_icon_widget(tb_zoomimg);
        tb.add(tb_zoom);
        db.add(tb);
        
        return db;
    }
}