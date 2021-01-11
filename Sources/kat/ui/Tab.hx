package kat.ui;

import zui.Zui.Layout;

class Tab {

    public var parent:Panel;
    public var position:Int = -1;
    public var active(get,null):Bool;
    public final name:String;
    @:isVar public var layout(get,null):Layout;
    function get_layout(){
        return layout;
    }
    
    public function new(tabname:String,?p_layout:Layout = Layout.Vertical){
        name = tabname;
        layout = p_layout;
    }
    function get_active(){
        if(parent == null)return false;
        return parent.visible && parent.htab.position == position;
    }
    public function redraw() {
        
    }
    public function render(ui:zui.Zui){

    }
}