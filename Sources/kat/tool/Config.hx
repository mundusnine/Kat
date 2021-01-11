package kat.tool;


import kat.tool.File;
import haxe.Json;
import haxe.io.Bytes;
import kha.Display;
import kat.tool.ConfigFormat;

class Config {

	public static var raw: TConfig = null;
	public static var keymap: Dynamic;
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
		var path ="./config.kat";
		var bytes = Bytes.ofString(Json.stringify(raw));
		File.saveBytes(path,bytes);
	}

	public static function init() {
		if (!configLoaded || raw == null) {
			raw = {};
			raw.locale = "system";
			raw.window_mode = 0;
			raw.window_resizable = true;
			raw.window_minimizable = true;
			raw.window_maximizable = true;
			raw.window_w = 1600;
			raw.window_h = 900;
			raw.window_x = -1;
			raw.window_y = -1;
			raw.window_scale = 1.0;
			raw.window_vsync = true;
			var disp = Display.primary;
			if (disp != null && disp.width >= 3000 && disp.height >= 2000) {
				raw.window_scale = 2.0;
			}
			#if (krom_android || krom_ios)
			raw.window_scale = 2.0;
			#end

			raw.sha = UIManager.sha;
			raw.bookmarks = [];
			raw.plugins = [];
			raw.keymap = "default.json";
			raw.theme = "dark.json";
		}
        
		loadKeymap();
	}

	public static function restore() {
		zui.Zui.Handle.global = new zui.Zui.Handle(); // Reset ui handles
		configLoaded = false;
		init();
		Translator.loadTranslations(raw.locale);
	}


	public static function loadKeymap() {
		var done = function(blob: kha.Blob) {
			keymap = Json.parse(blob.toString());
		} 
		kha.Assets.loadBlobFromPath("./data/keymap_presets/" + raw.keymap,done);
	}

	public static function saveKeymap() {
		var path = "./data/keymap_presets/" + raw.keymap;
		var bytes = Bytes.ofString(Json.stringify(keymap));
		File.saveBytes(path,bytes);
    }
    
}
