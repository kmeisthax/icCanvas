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
    
    /* Add a row onto the Dock without adding any Dockables to it.
     */
    public virtual void insert_new_row(Edge edge, uint before_row) {
    }
    
    /* Add a dockable widget to a particular edge of the dock.
     */
    public virtual void add_dockable(icCanvasGtk.Dockable dockwdgt, Edge edge) {
    }
    
    /* Add a dockable widget to a specified position on the dock.
     * Depending on the implementation, Edge and offsetFromEdge may not be used.
     */
    public virtual void add_dockable_positioned(icCanvasGtk.Dockable dockwdgt, Edge edge, uint offsetFromEdge, int pos) {
    }
    
    /* Delegate type for the foreach_rows method.
     * 
     * Returning FALSE cancels the iteration; the calling function will return
     * to it's parent.
     */
    public delegate bool RowIteratee(Edge edge, int rowIndex, icCanvasGtk.DockingBox row);
    
    /* Iterate over the rows of the dock.
     */
    public virtual void foreach_rows(RowIteratee i) {
    }
    
    /* Remove a row from the dock.
     * 
     * If the selected row still contains child dockables, those will also be
     * removed.
     * 
     * Some implementations may not support row removal.
     */
    public virtual void remove_row(Edge edge, uint offsetFromEdge) {
    }
    
    /* Fired when the Dock recieves a Dockable. */
    public signal void added_dockable(icCanvasGtk.Dockable dockable, icCanvasGtk.Dock? dock, icCanvasGtk.DockingBox? row);
}