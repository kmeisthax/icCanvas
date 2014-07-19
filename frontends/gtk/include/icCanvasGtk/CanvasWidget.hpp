#ifndef __ICCANVASGTK__CANVASWIDGET_HPP__
#define __ICCANVASGTK__CANVASWIDGET_HPP__

#include <gtkmm.h>
#include <icCanvasManager.hpp>

namespace icCanvasGtk {
    class CanvasWidget : public Gtk::Widget {
            icCanvasManager::RefPtr<icCanvasManager::CanvasView> cv;
            Glib::RefPtr<Gdk::Window> evtWindow;

            //GDK doesn't provide mouse event deltas, so we have to generate them ourselves
            double lastx, lasty;
        public:
            CanvasWidget();
            virtual ~CanvasWidget();
            
            void set_drawing(icCanvasManager::RefPtr<icCanvasManager::Drawing> newDoc);
        protected:
            virtual void on_realize() override;
            virtual void on_unrealize() override;

            virtual bool on_draw(const Cairo::RefPtr<Cairo::Context>& cr) override;

            virtual bool on_button_press_event(GdkEventButton *evt) override;
            virtual bool on_motion_notify_event(GdkEventMotion *evt) override;
            virtual bool on_button_release_event(GdkEventButton *evt) override;
    };
}

#endif
