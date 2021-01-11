package kat.ui;

import zui.Zui.Handle;
import zui.Canvas.TElement;

class Panel implements View {

    var tabs:Array<Tab> = [];
    public var htab:zui.Zui.Handle;
    public var tabname(get,null):String;
    public var visible:Bool = true;
    function get_tabname(){
        if(tabs.length == 0)return "";
        return tabs[htab.position].name;
    }
    public var windowHandle:zui.Zui.Handle;
    public var postRenders:Array<zui.Zui->Void>;
    var element:TElement = null;
    public var x(get,null):Int;
    function get_x(){
        if(element == null)return 0;
        return Std.int(element.x);
    }

    public var y(get,null):Int;
    function get_y(){
        if(element == null)return 0;
        return Std.int(element.y);
    }

    public var w(get,null):Int;
    function get_w(){
        if(element == null)return 0;
        return Std.int(element.width);
    }

    public var h(get,null):Int;
    function get_h(){
        if(element == null)return 0;
        return Std.int(element.height);
    }

    public function new(?visibleOnStart:Bool = true){
        postRenders = new Array<zui.Zui->Void>();
        windowHandle = new Handle();
        htab = new Handle({text: "",position: 0});
        visible = visibleOnStart;
    }
    @:access(zui.Zui)
    public function render(ui:zui.Zui,element:TElement):Void{
        if(this.element == null)
            this.element = element;
        if(tabs.length > 0){
            windowHandle.layout = tabs[htab.position].layout;
        }
        if(ui.window(windowHandle,x,y,w,h)){
            for (tab in tabs){
                tab.render(ui);
            }
        }
        for(r in postRenders){
            r(ui);
        }
    }
    public function redraw() {
        htab.redraws = windowHandle.redraws = 2;
    }
    public function addTab(tab:Tab){
        if(tabs.indexOf(tab) == -1){
            tab.position = tabs.push(tab)-1;
            tab.parent = this;
        }
    }
    public function removeTab(tab:Tab):Bool {
        if(tabs.remove(tab)){
            tab.parent = null;
            tab.position = -1;
        }
        return false;
    }
}