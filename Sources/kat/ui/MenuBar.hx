package kat.ui;

import kat.tool.Config;
import kat.Input;
import zui.Id;
import kha.Image;
import zui.Canvas.TElement;
import zui.Zui;
import zui.Ext;



class MenuBar implements View {

	public static inline var defaultMenubarW = 330;

	var ui:zui.Zui;
	public var workspaceHandle = new Handle({layout: Horizontal});
	public var menuHandle = new Handle({layout: Horizontal});
	public var menubarw = defaultMenubarW;
	public  var y:Float = 0.0;
	
	var visible:Bool = false;
	
	var playImage:kha.Image;
	var pauseImage:kha.Image;
	var mouse:Mouse;
	var delta:Float;
	var current:Float;
	public function new() {

	}
	function shouldRedraw(image:kha.Image,width:Float,height:Float){
		var should = image == null;
		should = should ? should : image.width != width || image.height != height;
		return should;

	}
	var animateIn:Bool = false;
	var animateOut:Bool = false;
	var lastColor:kha.Color = kha.Color.White;
	@:access(zui.Zui)
	public function render(ui:Zui,element:TElement) {
		this.ui = ui;
		if(mouse == null) mouse = Input.getMouse();
		
		var main = Main.uiMain;

		//Hide or show menu bar
		if(visible && !animateOut && !Menu.show && mouse.y > element.height){
			animateOut = true;
			y = element.y;
			current =  kha.Scheduler.time();
		}
		else if(!animateIn && mouse.y < element.height){
			animateIn = true;
			y = 0;
			visible = true;
			current = kha.Scheduler.time();
		}

		if(main.currentView > 0){
			visible = animateIn = animateOut = true;
		}
		
		if(!visible && !animateIn && !animateOut)return;

		delta = kha.Scheduler.time() -current;
        current =  kha.Scheduler.time();

		if(main.currentView == 0){
			if(animateIn){
				// y = Util.lerp(0,element.y,delta);
				if(y >= element.y){
					animateIn = false;
				}
			}
			else if(animateOut){
				// y = Util.lerp(element.y,0,delta);
				if(y <= 0.1){
					animateOut = false;
					y = 0;
					visible = false;
				}
			}
		}

		//Draw the ui
		ui.inputEnabled = true;
		var WINDOW_BG_COL = ui.t.WINDOW_BG_COL;
		ui.t.WINDOW_BG_COL = ui.t.SEPARATOR_COL;
		if (ui.window(menuHandle, Std.int(element.x), Std.int(this.y), Std.int(element.width),Std.int(element.height))) {
			var w = ui.BUTTON_H() > element.height ? element.height: ui.BUTTON_H();
			var _w = ui._w;
			ui._x += 1; // Prevent "File" button highlight on startup
			var but_h = ui.t.BUTTON_H;
			ui.t.BUTTON_H = Std.int(element.height);
			Ext.beginMenu(ui);

			ui.t.BUTTON_H = but_h;

			var menuCategories = 3;
			for (i in 0...menuCategories) {
				var categories = [tr("File"), tr("Edit"), tr("Help")];
				var pressed = Ext.menuButton(ui, categories[i]);
				if(pressed && Menu.show){
					Menu.show = false;
				}
				else if (pressed || (Menu.show && Menu.menuCommands == null && ui.isHovered)) {
					Menu.show = true;
					Menu.menuCategory = i;
					Menu.menuX = Std.int(ui._x - ui._w);
					Menu.menuY = Std.int(Ext.MENUBAR_H(ui));
				}
			}

			if (menubarw < ui._x + 10) {
				menubarw = Std.int(ui._x + 10);
			}

			ui._w = _w;
			ui._x = element.width * 0.5;
			ui._y = 0.0;
			ui._w = Std.int(ui._w + ui.ELEMENT_W());
			main.currentView = Ext.inlineRadio(ui,Id.handle(),["Local","Online"]);
			Ext.endMenu(ui);

			ui._x = ui._w-ui.ELEMENT_W() * 2;//This removes a line under the menu bar... its weird.
		}
		ui.t.WINDOW_BG_COL = WINDOW_BG_COL;
		//This only works if the menu is the first to be drawn; this may be buggy... @:TODO
		ui.inputEnabled = !Menu.show;
	}
	public function redraw() {
		menuHandle.redraws = 2;
	}
}
