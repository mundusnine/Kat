package kat.tool;

import haxe.iterators.DynamicAccessKeyValueIterator;
import haxe.io.Path;
import kat.tool.FileSystem;
import kha.Assets;
import haxe.Json;
import kha.System;
class Translator {

	static var translations: Map<String, String> = [];

	// Localizes a string with the given placeholders replaced (format is `{placeholderName}`).
	// If the string isn't available in the translation, this method will return the source English string.
	public static function tr(id: String, vars: Map<String, String> = null): String {
		var translation:String = id;
		// English is the source language
		if (Config.raw != null && Config.raw.locale != "en" && translations.exists(id)) {
			var trans = translations[id];
			if(trans != null)translation = trans;
		}

		if (vars != null) {
			for (key => value in vars) {
				translation = translation.replace('{$key}', Std.string(value));
			}
		}

		return translation;
	}

	// (Re)loads translations for the specified locale.
	public static function loadTranslations(newLocale:Null<String>) {
		if (newLocale == "system") {
            #if krom
            Config.raw.locale = Krom.language();
            #else
            if (Config.raw != null)Config.raw.locale = System.language;
            #end

		}

		// Check whether the requested or detected locale is available
		if (Config.raw != null && Config.raw.locale != "en" && newLocale != null && getSupportedLocales().indexOf(newLocale) == -1) {
			// Fall back to English
			Config.raw.locale = "en";
		}

		if (Config.raw != null && Config.raw.locale == "en") {
			// No translations to load, as source strings are in English.
			// Clear existing translations if switching languages at runtime.
			translations.clear();
			return;
		}

		// Load the translation file
		if (Config.raw != null){
			Assets.loadBlobFromPath('./data/locale/${Config.raw.locale}.json',function(blob:kha.Blob){
				var translationJson = blob.toString();
				// var data: haxe.DynamicAccess<String> = ;
				var itData:DynamicAccessKeyValueIterator<String> = new DynamicAccessKeyValueIterator(Json.parse(translationJson));
				while(itData.hasNext()){
					var data:Dynamic = itData.next();
					translations[Std.string(data.key)] = data.value;
				}
		
				// Generate extended font atlas
				// Basic Latin + Latin-1 Supplement + Latin Extended-A
				kha.graphics2.Graphics.fontGlyphs = [for (i in 32...383) i];
			});
		}
        
	}

	// Returns a list of supported locales (plus English and the automatically detected system locale).
	public static function getSupportedLocales(): Array<String> {
        var locales = ["system", "en"];
        var path = "./data/locale/";
		//@TODO: Fix this to have translation files. In theory, the asset files will be available locally.
		for (localeFilename in FileSystem.readDirectory(path)) {
			// Trim the `.json` file extension from file names
			locales.push(localeFilename.substr(0, -5));
		}

		return locales;
	}
}
