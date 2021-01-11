package kat.tool;

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
		var translation = id;
		// English is the source language
		if (Config.raw.locale != "en" && translations.exists(id)) {
			translation = translations[id];
		}

		if (vars != null) {
			for (key => value in vars) {
				translation = translation.replace('{$key}', Std.string(value));
			}
		}

		return translation;
	}

	// (Re)loads translations for the specified locale.
	public static function loadTranslations(newLocale: String) {
		if (newLocale == "system") {
            #if krom
            Config.raw.locale = Krom.language();
            #else
            Config.raw.locale = System.language;
            #end

		}

		// Check whether the requested or detected locale is available
		if (Config.raw.locale != "en" && getSupportedLocales().indexOf(newLocale) == -1) {
			// Fall back to English
			Config.raw.locale = "en";
		}

		if (Config.raw.locale == "en") {
			// No translations to load, as source strings are in English.
			// Clear existing translations if switching languages at runtime.
			translations.clear();
			return;
		}

        // Load the translation file
        Assets.loadBlobFromPath('./data/locale/${Config.raw.locale}.json',function(blob:kha.Blob){
            var translationJson = blob.toString();
            var data: haxe.DynamicAccess<String> = Json.parse(translationJson);
            for (key => value in data) {
                translations[Std.string(key)] = value;
            }
    
            // Generate extended font atlas
            // Basic Latin + Latin-1 Supplement + Latin Extended-A
            kha.graphics2.Graphics.fontGlyphs = [for (i in 32...383) i];
		});
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
