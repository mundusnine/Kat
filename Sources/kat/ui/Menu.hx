package kat.ui;

import zui.Ext;
import zui.Id;
import kha.System;

import zui.Zui;

import kat.Url;

import kat.tool.Config;


@:enum abstract MenuCategory(Int) from Int to Int {
	var MenuFile = 0;
	var MenuEdit = 1;
	var MenuHelp = 2;
}


class Menu {
    
    public static var show = false;
	public static var menuCategory = 0;
	public static var menuX = 0;
    public static var menuY = 0;
    public static var menuW = 0;
    public static var menuH(get,null):Float;
    static function get_menuH() {
        return  kat.UIManager.popupui.ELEMENT_H() * menuItemsCount[menuCategory];
    }
	public static var menuElements = 0;
	public static var keepOpen = false;
	public static var menuCommands: Zui->Void = null;
	static var changeStarted = false;
	static var showMenuFirst = true;
	static var hideMenu = false;

    public function new() {
    }
    
    static var drawGridHandle:Handle = Id.handle({selected:true});
    static var physicsDebugHandle:Handle = Id.handle({selected:false});
    static var camControlLeftHandle:Handle = Id.handle();
    static var camControlRightHandle:Handle = Id.handle();
    static var camControlUpHandle:Handle = Id.handle();
    static var camControlDownHandle:Handle = Id.handle();
    static final menuItemsCount = [6, 1, 3];
    @:access(zui.Zui,EditorUi,EditorHierarchy)
    public static function render(g:kha.graphics2.Graphics){

        var ui = kat.UIManager.popupui;

        menuW = Std.int(ui.ELEMENT_W() * 2.0);

        var BUTTON_COL = ui.t.BUTTON_COL;
		ui.t.BUTTON_COL = ui.t.SEPARATOR_COL;
		var ELEMENT_OFFSET = ui.t.ELEMENT_OFFSET;
        ui.t.ELEMENT_OFFSET = 0;
        
        g.begin(false);
        ui.beginRegion(g, menuX, menuY, menuW);

        var sepw = menuW / ui.SCALE();
        ui.g.color = ui.t.SEPARATOR_COL;
        ui.g.fillRect( menuX, menuY, menuW, menuH);
        
        //Begin
        
        if (menuCategory == MenuFile) {
            if (ui.button("      " + tr("New Scene..."), Left, Config.keymap.file_new)){
                show = false;
            }
            if (ui.button("      " + tr("Open..."), Left, Config.keymap.file_open)){
                show = false;
            }
            if (ui.button("      " + tr("Save"), Left, Config.keymap.file_save)){
                show = false;
            }
            if (ui.button("      " + tr("Save As..."), Left, Config.keymap.file_save_as)){
                show = false;
            }
            if (ui.button("      " + tr("Export Project files..."), Left)){
                show = false;
            }
            ui.fill(0, 0, sepw, 1, ui.t.ACCENT_SELECT_COL);
            if (ui.button("      " + tr("Exit"), Left)){ 
                System.stop();
                show = false;
            }
        }
        else if (menuCategory == MenuEdit) {
            if (ui.button("      " + tr("Preferences..."), Left, Config.keymap.edit_prefs)){
                show = false;
            }
        }
        else if (menuCategory == MenuHelp) {
            if (ui.button("      " + tr("Manual"), Left)) {
                Url.explorer("https://github.com/foundry2D/foundry2d/wiki");
            }
            if (ui.button("      " + tr("Issue Tracker"), Left)) {
                Url.explorer("https://github.com/foundry2D/foundry2d/issues");
            }
            if (ui.button("      " + tr("Report Bug"), Left)) {
                var url = "https://github.com/foundry2D/foundry2d/issues/new?labels=bug&template=bug_report.md&body=*Foundry2d%20" + UIManager.sha + ",%20" + System.systemId + "*";
                Url.explorer(url);
            }
        }

        //End
        var first = showMenuFirst;
		hideMenu = ui.comboSelectedHandle == null && !changeStarted && !keepOpen && !first && (ui.changed || ui.inputReleased || ui.inputReleasedR || ui.isEscapeDown);
		showMenuFirst = false;
		keepOpen = false;
		if (ui.inputReleased) changeStarted = false;

		ui.t.BUTTON_COL = BUTTON_COL;
		ui.t.ELEMENT_OFFSET = ELEMENT_OFFSET;
        ui.endRegion();
        g.end();
    }
}