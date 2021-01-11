package kat.ui;

import zui.Zui;
import zui.Canvas.TElement;

class AppView  extends UICanvas {
    var ui:Zui;
    var toDraw:Map<String,View>;
    final firstElem:String;
    final lastElem:String;
    public function new(ui:zui.Zui,canvasname:String) {
        this.ui = ui;
        super(canvasname,kha.Assets.blobs.get(canvasname+"_json"));
        ui.ops.theme = zui.Canvas.themes[0];
        toDraw = new Map<String,View>();
        for(elem in canvas.elements){
            this.addCustomDraw(elem.name,drawEditorView);
        }
        firstElem = canvas.elements[0].name;
        lastElem = canvas.elements[canvas.elements.length-1].name;
    }
    public function addToElementDraw(name:String,view:View){
        toDraw.set(name,view);
    }
    function drawEditorView(g:kha.graphics2.Graphics,element:TElement) {
        if(element.name == firstElem)
            ui.begin(g);
        var drawable = toDraw.get(element.name);
        if(drawable != null){
            drawable.render(ui,element);
        }
        else{
            trace("No ui will be drawn for element named: " + element.name);
        }
        if(element.name == lastElem)
            ui.end();
    }

}
