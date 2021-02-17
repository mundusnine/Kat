package kat.ui;

import zui.Zui;
import zui.Id;

class FileBrowserDialog {
    static public var inst:FileBrowserDialog = null;

    public static function open(onDone:String->Void,?currentPath:String = "."){
        #if kha_cpp
        if(currentPath == '.'){
            currentPath = sys.FileSystem.absolutePath(currentPath);
        }
        #end
        doneCallback = onDone;
        fbHandle.text = currentPath ; 
        zui.Popup.showCustom(UIManager.popupui, fileBrowserPopupDraw, -1, -1, Std.int(UIManager.popupui.ELEMENT_W() * 4),Std.int(UIManager.popupui.ELEMENT_W() * 3));
    }
    static var doneCallback:String->Void = function(path:String){};
    static var fbHandle:Handle = Id.handle();
    static var textInputHandle = Id.handle();
    @:access(zui.Zui, zui.Popup)
    static function fileBrowserPopupDraw(ui:Zui){
        zui.Popup.boxTitle = tr("File Browser");

        var selectedFile = zui.Ext.fileBrowser(ui,fbHandle);
        if(fbHandle.changed){
            textInputHandle.text = selectedFile;
        }
        
        ui.endElement();
        
        ui.textInput(fbHandle, tr("Path"));

        ui.row([0.5,0.5]);
        // ui._y = ui._h - ui.t.BUTTON_H - border;
        ui.text("");
        ui.row([0.5, 0.5]);
		if (ui.button(tr("Add"))) {
            zui.Popup.show = false;
            doneCallback(textInputHandle.text);
            textInputHandle.text = "";
            doneCallback = function(path:String){};
        }
        if (ui.button(tr("Cancel"))) {
            zui.Popup.show = false;
            textInputHandle.text = "";
            doneCallback("");
            doneCallback = function(path:String){};
        }


        if(ui._y < zui.Popup.modalH)
			ui._y = zui.Popup.modalH;
    }
}