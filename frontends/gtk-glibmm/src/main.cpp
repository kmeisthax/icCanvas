#include <gtkmm.h>
#include <icCanvasManager.hpp>
#include <icCanvasGtk.hpp>

int main (int argc, char *argv[]) {
    Glib::RefPtr<Gtk::Application> app = Gtk::Application::create(argc, argv, "org.fantranslation.code.icCanvas.gtk");

    Gtk::Window window;
    window.set_default_size(400, 400);

    icCanvasGtk::CanvasWidget canvasWdgt;
    canvasWdgt.set_size_request(100, 100);

    window.add(canvasWdgt);
    window.show_all();

    icCanvasManager::RefPtr<icCanvasManager::Drawing> doc = new icCanvasManager::Drawing();
    canvasWdgt.set_drawing(doc);

    return app->run(window);
}
