package kat;

import kat.ui.LocalLibrary;
import kat.ui.SidePanel;
import kat.ui.SideTab;
import kat.ui.Panel;
import kat.tool.Config;
import kat.ui.MenuBar;
import kat.tool.BuildMacros;
import kat.ui.AppView;
import kha.graphics2.Graphics;
import zui.Zui;
import kat.ui.Menu;

class UIManager {

    var ui:Zui;
    static var _endFrame:Array<Void->Void> = [];
    public static var sha:String = BuildMacros.sha();
    public static var popupui:Null<Zui>;
    public static var title_size = 48;
    var menu:MenuBar;
    public function new() {
        ui = new Zui({font: kha.Assets.fonts.font_default});
        popupui = new Zui({font: kha.Assets.fonts.font_default});
        Config.init();
        listViews.push(new AppView(ui,"main"));
        menu  = new MenuBar();
        var elemName = "Header";
        listViews[0].addToElementDraw(elemName,menu);
        var sidePanel = new SidePanel();
        sidePanel.addTab(new SideTab());
        listViews[0].addToElementDraw("Side",sidePanel);
        var mainPanel = new Panel();
        mainPanel.addTab(new LocalLibrary());
        listViews[0].addToElementDraw("Main",mainPanel);

    }
    
    @:access(kat.ui.AppView)
    public function render(g2:Graphics) {

        var isClear = true;
        var bgColor = isClear ? ui.t.WINDOW_BG_COL : null;

        ui.enabled = !zui.Popup.show; 

        if(listViews.length > 0 && listViews[currentView].ready && listViews[currentView].visible){
            g2.begin(isClear,bgColor);
            for(f in listViews[currentView]._render2D)f(g2);
            g2.end();
        }
        if(Menu.show){
            Menu.render(g2);
        }
        if(zui.Popup.show){
            zui.Popup.render(g2);
        }
        //EndFrame
        for(f in _endFrame) f();
    }

    public function update() {
        
    }

    public var currentView(default,set):Int = 0;
    function set_currentView(value:Int){
        if(value > listViews.length-1)throw 'View with number $value is higher then the number of views available.';
        currentView = value;
        redraw();
        return currentView;
    }

    var listViews:Array<AppView> = [];
    @:access(kat.ui.AppView)
    public function redraw() {
        for (view in listViews[currentView].toDraw){
            view.redraw();
        }
    }

    public static function notifyOnEndFrame(endFrame:Void->Void) {
        _endFrame.push(endFrame);
    }
}