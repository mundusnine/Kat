package kat.tool;

#if kha_kore
typedef FileSystem = sys.FileSystem;
#elseif kha_debug_html5
class FileSystem {
    public static function readDirectory(path:String):Array<String> {
        return [];
    }
    public static function exists(path:String):Bool{
        return false;
    }
}
#end