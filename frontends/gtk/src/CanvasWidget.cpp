#include <icCanvasGtk.hpp>

icCanvasGtk::CanvasWidget::CanvasWidget() :
    Glib::ObjectBase("icCanvasGtkCanvasWidget"), Gtk::Widget()
{
    this->set_has_window(false);
    this->r = new icCanvasManager::Renderer();
};
icCanvasGtk::CanvasWidget::~CanvasWidget() {};

void icCanvasGtk::CanvasWidget::set_drawing(icCanvasManager::RefPtr<icCanvasManager::Drawing> newDoc) {
    this->doc = newDoc;
}

bool icCanvasGtk::CanvasWidget::on_draw(const Cairo::RefPtr<Cairo::Context>& cr) {
    auto strokePtr = this->doc->begin(), end = this->doc->end();
    auto capi_cr = (cairo_t*)cr->cobj();
    
    auto clear_ptn = Cairo::SolidPattern::create_rgb(1.0f, 1.0f, 1.0f);
    
    cr->save();
    cr->set_source(clear_ptn);
    cr->paint();
    
    this->r->enterContext(0, 0, 14, capi_cr, this->get_allocated_height(), this->get_allocated_width());
    
    for (; strokePtr != end; strokePtr++) {
        this->r->drawStroke(*strokePtr);
    }
    
    cr->restore();
    
    return true;
}
