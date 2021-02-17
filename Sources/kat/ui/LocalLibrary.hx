package kat.ui;

import zui.Ext;
import zui.Id;
import haxe.Json;
import zui.Zui;
import kat.tool.File;
import kat.tool.FileSystem;

typedef LibraryEntries = {
    var paths:Array<String>;
} 

class LocalLibrary  extends Tab {
    public function new() {
        super(tr("Local Library"));
    }
    var tint:Int = 0xffffffff;
    var savedContent:Null<LibraryEntries> = null;
    var savedPath = './lcllbry.kat';
    var listHandle = Id.handle();
    @:access(zui.Zui)
    override function render(ui:Zui) {
        
        var f_size = ui.fontSize;
        ui.fontSize = UIManager.title_size;
        ui.text(tr(this.name));
        ui.fontSize = f_size;
        
        ui.text("");// A space
        ui._y -= ui.ELEMENT_H() * 0.5;

        
        var panelHandle = Id.handle();
        if(ui.panel(panelHandle,"")){

            var div = 0.1;
            ui.t.BUTTON_COL = ui.t.SEPARATOR_COL;
            ui.row([div,div*2,div,1.0-div*4]);
            var bump_x = this.parent.w * div - ui.FONT_SIZE() * 2;
            var last_y = ui._y;
            ui._x = bump_x;
            ui._y += ui.TEXT_OFFSET();
            var state = ui.image(kha.Assets.images.folderOpen,tint,ui.FONT_SIZE());
            ui._x += -bump_x;
            ui._y = last_y;

            if(state == State.Hovered){
                tint = ui.t.ACCENT_HOVER_COL;
            }
            else {
                tint = 0xffffffff;
            }
            
            if(ui.button(tr("Add Folder")) || state == State.Down) {
                if(savedContent == null){
                    if(FileSystem.exists(savedPath)){
                        savedContent = Json.parse(File.getBytes(savedPath).toString());
                    }
                    else {
                        savedContent = {paths: []};
                    }
                }
                var done = function (path:String){
                    if(path != ""){
                        var shouldAdd = true;
                        for(p in savedContent.paths){
                            if(p == path){
                                shouldAdd = false;
                                break;
                            }
                        }
                        if(shouldAdd){
                            savedContent.paths.push(path);
                        }
                    }
                };
                var lastPath = savedContent.paths.length > 0 ? savedContent.paths[savedContent.paths.length-1] : "."; 
                FileBrowserDialog.open(done,lastPath);
            }
    
            if(ui.button(tr("Refresh"))){
    
            }
            ui.separator();
            
            if(savedContent != null && savedContent.paths.length > 0){
                Ext.list(ui,listHandle,savedContent.paths);
            }
        }
        
    }

}