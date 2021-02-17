package kat.tool;


import kat.tool.File;
import haxe.Json;
import haxe.io.Bytes;
import kha.Display;
import kat.tool.ConfigFormat;

class Config {

	public static var raw: Null<TConfig> = null;
	public static var keymap: Null<Dynamic>;
	public static var configLoaded = false;

	public static function load(done: Void->Void) {
		try {
			kha.Assets.loadBlobFromPath("./config.kat", function(blob: kha.Blob) {
				configLoaded = true;
				raw = Json.parse(blob.toString());
				done();
			});
		}
		catch (e: Dynamic) { trace("Failed to load, will load defaults");done(); }
	}

	public static function save() {
		// Use system application data folder
		// when running from protected path like "Program Files"
		if(raw != null){
			var path ="./config.kat";
			var bytes = Bytes.ofString(Json.stringify(raw));
			File.saveBytes(path,bytes);
		}
		
	}

	public static function init() {
		if (!configLoaded || raw == null) {
			raw = {window_mode: 0,window_resizable: true,window_minimizable: true,window_maximizable: true,window_w: 1600,window_h: 900,window_x: -1,window_y: -1,window_scale: 1.0,window_vsync: true};
			raw.locale = "system";
			var disp = Display.primary;
			if (disp != null && disp.width >= 3000 && disp.height >= 2000 && raw != null && raw.window_scale != null) {
				raw.window_scale = 2.0;
			}
			#if (krom_android || krom_ios)
			raw.window_scale = 2.0;
			#end

			 
			if(raw != null)raw.sha = UIManager.sha;
			if(raw != null)raw.bookmarks = [];
			if(raw != null)raw.plugins = [];
			if(raw != null)raw.keymap = "default.json";
			if(raw != null)raw.theme = "dark.json";
		}
        
		loadKeymap();
	}

	public static function restore() {
		zui.Zui.Handle.global = new zui.Zui.Handle(); // Reset ui handles
		configLoaded = false;
		init();
		if(raw != null)Translator.loadTranslations(raw.locale);
	}


	public static function loadKeymap() {
		var done = function(blob: kha.Blob) {
			keymap = Json.parse(blob.toString());
		} 
		if(raw != null)kha.Assets.loadBlobFromPath("./data/keymap_presets/" + raw.keymap,done);
	}

	public static function saveKeymap() {
		if(raw == null || keymap == null) return;
		var path = "./data/keymap_presets/" + raw.keymap;
		var bytes = Bytes.ofString(Json.stringify(keymap));
		File.saveBytes(path,bytes);
    }
    
}
