/* A Dock is responsible for managing Dockable widgets which users and program
 * code may place along the margins of a single main widget.
 */
interface icCanvasGtk.Dock : GLib.Object {
    public enum Edge {
        TOP,
        LEFT,
        RIGHT,
        BOTTOM
    }
    
    public virtual void insert_new_row(Edge edge, uint before_row) {
    }
    
    /* Add a dockable widget to a particular edge of the dock.
     * Depending on the implementation, Edge and offsetFromEdge may not be used.
     */
    public virtual void add_dockable(icCanvasGtk.Dockable dockwdgt, Edge edge) {
    }
    
    public virtual void add_dockable_positioned(icCanvasGtk.Dockable dockwdgt, Edge edge, uint offsetFromEdge, int pos) {
    }
    
    public signal void added_dockable(icCanvasGtk.Dockable dockable, icCanvasGtk.Dock? dock, icCanvasGtk.DockingBox? row);
}