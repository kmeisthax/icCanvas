#include <gtkmm.h>
#include <icCanvasManager.hpp>
#include <icCanvasGtk.hpp>

int main (int argc, char *argv[]) {
    Glib::RefPtr<Gtk::Application> app = Gtk::Application::create(argc, argv, "org.fantranslation.code.icCanvas.gtk");
    
    Gtk::Window window;
    window.set_default_size(400, 400);
    
    return app->run(window);
}