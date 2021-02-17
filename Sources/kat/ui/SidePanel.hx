package kat.ui;

import zui.Zui;
import zui.Canvas.TElement;

class SidePanel extends Panel{
    public function new() {
        super();
    }
    override function render(ui:Zui, element:TElement) {
        var wind_col = ui.t.WINDOW_BG_COL;
        var isFill = ui.t.FILL_WINDOW_BG;
        ui.t.FILL_WINDOW_BG = true;
        ui.t.WINDOW_BG_COL = ui.t.SEPARATOR_COL;
        super.render(ui,element);
        ui.t.WINDOW_BG_COL = wind_col;
        ui.t.FILL_WINDOW_BG = isFill;
    }
}