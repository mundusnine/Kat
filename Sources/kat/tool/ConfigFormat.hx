package kat.tool;

typedef TConfig = {
	// The locale should be specified in ISO 639-1 format: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
	// "system" is a special case that will use the system locale
	@:optional var locale: String;
	// Window
	@:optional var window_mode: Null<Int>; // window, fullscreen
	@:optional var window_w: Null<Int>;
	@:optional var window_h: Null<Int>;
	@:optional var window_x: Null<Int>;
	@:optional var window_y: Null<Int>;
	@:optional var window_resizable: Null<Bool>;
	@:optional var window_maximizable: Null<Bool>;
	@:optional var window_minimizable: Null<Bool>;
	@:optional var window_vsync: Null<Bool>;
	@:optional var window_scale: Null<Float>;
	// Application
	@:optional var sha: String; // Commit id
	@:optional var bookmarks: Array<String>; // Bookmarked folders in browser
	@:optional var plugins: Array<String>; // List of enabled plugins
	@:optional var keymap: String; // Link to keymap file
	@:optional var theme: String; // Link to theme file
}
