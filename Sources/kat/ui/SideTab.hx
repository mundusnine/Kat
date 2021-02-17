package kat.ui;

import zui.Zui.Align;

class SideTab extends Tab {
    public function new() {
        super(tr("SidePanel"));
        explores.push(tr("New Music"));
        explores.push(tr("Moods"));
        explores.push(tr("Genres"));
        explores.push(tr("Greatest Hits"));
        explores.push(tr("Local Library"));
    }
    var explores:Array<String> = [];
    @:access(zui.Zui)
    override public function render(ui:zui.Zui){
        
        var but_col =  ui.t.BUTTON_COL; 
        var tab_w = ui.t.TAB_W;
        var div = 0.1;
        ui.t.TAB_W = Std.int(this.parent.w * div + tab_w);
        ui.t.BUTTON_COL = ui.t.SEPARATOR_COL;
        ui.row([div,1.0-div]);
        var bump_x = this.parent.w * div - ui.FONT_SIZE();
        var last_y = ui._y;
        ui._x = bump_x;
        ui._y += ui.TEXT_OFFSET();
        ui.image(kha.Assets.images.fire,0xffffffff,ui.FONT_SIZE());
        ui._x += -bump_x;
        ui._y = last_y;
        ui.text(tr("Explore"));
        ui.indent(false);
        var i = 0;
        while(i < explores.length){
            if(ui.button(tr(explores[i]),Align.Left)){

            }
            i++;
        }

        ui.unindent(false);

        ui.separator();
        
        ui.row([div,1.0-div-0.2,0.2]);
        last_y = ui._y;
        ui._x = bump_x;
        ui._y += ui.TEXT_OFFSET();
        ui.image(kha.Assets.images.music,0xffffffff,ui.FONT_SIZE());
        ui._x += -bump_x;
        ui._y = last_y;
        ui.text(tr("My Playlists"));
        if(ui.button("+")){
            //Add me baby
        }

        ui.t.BUTTON_COL = but_col;
        ui.t.TAB_W = tab_w;
    }
}