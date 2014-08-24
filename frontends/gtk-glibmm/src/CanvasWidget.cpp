#include <icCanvasGtk.hpp>
#include <iostream>

icCanvasGtk::CanvasWidget::CanvasWidget() :
    Glib::ObjectBase(typeid(icCanvasGtk::CanvasWidget)),
    Gtk::Widget(),
    Gtk::Scrollable(),
    lastx(0), lasty(0)
{
    this->add_events(Gdk::BUTTON_MOTION_MASK | Gdk::BUTTON_PRESS_MASK | Gdk::BUTTON_RELEASE_MASK);
    this->set_has_window(true);
    this->cv = new icCanvasManager::CanvasView();
};
icCanvasGtk::CanvasWidget::~CanvasWidget() {};

void icCanvasGtk::CanvasWidget::set_drawing(icCanvasManager::RefPtr<icCanvasManager::Drawing> newDoc) {
    this->cv->attach_drawing(newDoc);
}

void icCanvasGtk::CanvasWidget::on_realize() {
    this->set_realized();

    if (!this->evtWindow) {
        GdkWindowAttr attributes;
        memset(&attributes, 0, sizeof(attributes));

        auto allocation = this->get_allocation();

        attributes.x = allocation.get_x();
        attributes.y = allocation.get_y();
        attributes.width = allocation.get_width();
        attributes.height = allocation.get_height();

        attributes.event_mask = this->get_events() | Gdk::EXPOSURE_MASK;
        attributes.window_type = GDK_WINDOW_CHILD;
        attributes.wclass = GDK_INPUT_OUTPUT;

        this->evtWindow = Gdk::Window::create(this->get_parent_window(), &attributes, GDK_WA_X | GDK_WA_Y);
        this->set_window(this->evtWindow);

        this->evtWindow->set_user_data(this->gobject_);
    }
}

void icCanvasGtk::CanvasWidget::on_size_allocate(Gtk::Allocation& allocation) {
    Gtk::Widget::on_size_allocate(allocation);

    if (this->get_realized()) {
        this->evtWindow->move_resize(allocation.get_x(), allocation.get_y(), allocation.get_width(), allocation.get_height());
        this->cv->set_size(allocation.get_width(), allocation.get_height(), this->get_scale_factor());
    }
};

void icCanvasGtk::CanvasWidget::on_unrealize() {
    this->evtWindow.reset();
    Gtk::Widget::on_unrealize();
}

bool icCanvasGtk::CanvasWidget::on_draw(const Cairo::RefPtr<Cairo::Context>& cr) {
    auto capi_cr = (cairo_t*)cr->cobj();

    this->cv->draw(capi_cr);

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

        this->queue_draw();
    }

    return true;
}