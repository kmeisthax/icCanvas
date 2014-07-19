#include <icCanvasGtk.hpp>

icCanvasGtk::CanvasWidget::CanvasWidget() :
    Glib::ObjectBase("icCanvasGtkCanvasWidget"), Gtk::Widget(),
    lastx(0), lasty(0)
{
    this->set_has_window(false);
    this->cv = new icCanvasManager::CanvasView();
    this->add_events(Gdk::BUTTON_MOTION_MASK | Gdk::BUTTON_PRESS_MASK | Gdk::BUTTON_RELEASE_MASK);
};
icCanvasGtk::CanvasWidget::~CanvasWidget() {};

void icCanvasGtk::CanvasWidget::set_drawing(icCanvasManager::RefPtr<icCanvasManager::Drawing> newDoc) {
    this->cv->attach_drawing(newDoc);
}

bool icCanvasGtk::CanvasWidget::on_draw(const Cairo::RefPtr<Cairo::Context>& cr) {
    auto capi_cr = (cairo_t*)cr->cobj();
    
    this->cv->set_size(this->get_allocated_width(), this->get_allocated_height());
    
    cairo_rectangle_t dirtyRect;
    double x1, y1, x2, y2;
    cairo_clip_extents(capi_cr, &x1, &y1, &x2, &y2);
    dirtyRect.x = x1;
    dirtyRect.y = y1;
    dirtyRect.width = x2 - x1;
    dirtyRect.height = y2 - y1;
    this->cv->draw(capi_cr, dirtyRect);
    
    return true;
}

bool icCanvasGtk::CanvasWidget::on_button_press_event(GdkEventButton *evt) {
    if (evt->type == GDK_BUTTON_PRESS) {
        this->cv->mouse_down(evt->x, evt->y, 0, 0);

        this->lastx = evt->x;
        this->lasty = evt->y;
    }

    return true;
}

bool icCanvasGtk::CanvasWidget::on_motion_notify_event(GdkEventMotion *evt) {
    this->cv->mouse_drag(evt->x, evt->y, evt->x - this->lastx, evt->y - this->lasty);

    this->lastx = evt->x;
    this->lasty = evt->y;

    return true;
}

bool icCanvasGtk::CanvasWidget::on_button_release_event(GdkEventButton *evt) {
    if (evt->type == GDK_BUTTON_RELEASE) {
        this->cv->mouse_up(evt->x, evt->y, evt->x - this->lastx, evt->y - this->lasty);

        this->lastx = evt->x;
        this->lasty = evt->y;
    }

    return true;
}
