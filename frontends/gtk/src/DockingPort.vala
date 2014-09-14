/* A DockingPort can operate in three modes depending on the state of related
 * DockingPorts. The default mode is DISINTERESTED, where the DockingPort is
 * not expecting to receive or send any Dockables, and events flow to children
 * normally.
 * 
 * In RECEIVING mode, the DockingPort is expecting to receive a widget from a
 * widget in SENDING mode. These two modes are triggered whenever the user
 * begins dragging a Dockable from a DockingPort. The DockingPort which
 * currently owns the Dockable switches into SENDING mode and fires it's
 * mode_changed signal, which is propagated upwards to parent Ports, and then
 * to children as connect_after. DockingPorts that receive the related after
 * mode_changed signal may decide to enter RECEIVING mode if the offered
 * Dockable is compatible, otherwise, they will stay DISINTERESTED.
 * 
 * When the user releases their mouse over a RECEIVING DockingPort, it will
 * inform the SENDING DockingPort that it is taking ownership of the offered
 * Dockable, then place said Dockable within itself and configure it's
 * orientation appropriately.
 * 
 * The parent Dock also participates in this signal. Aside from the simple job
 * of forwarding mode_will_change signals to mode_did_change signals, it will
 * also monitor the user's mouse position, create new DockingPorts to house
 * Dockables dropped over DISINTERESTED DockingPorts as needed, and other
 * housekeeping tasks.
 */

interface icCanvasGtk.DockingPort : GLib.Object {
    public enum PortMode {
        DISINTERESTED,
        SENDING,
        RECEIVING
    }
    
    /* Used to indicate that a docking port (or a subwidget of a Port) has changed it's
     * mode.
     */
    public signal void mode_changed(icCanvasGtk.DockingPort src, icCanvasGtk.DockingPort.PortMode mode);
    
    public abstract icCanvasGtk.DockingPort? parent_port { set; }
    
    public abstract icCanvasGtk.Dockable? offered_dockable { get; set; }
    
    public abstract void accept_offer(icCanvasGtk.DockingPort foreign_port);
}