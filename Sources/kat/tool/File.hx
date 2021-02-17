package kat.tool;

#if kha_kore
typedef File = sys.io.File;
#elseif kha_debug_html5
import haxe.io.Bytes;
class File {
    public static function saveBytes(path:String,bytes:Bytes) {
        
    }
    public static function getBytes(path:String):haxe.io.Bytes {
        return haxe.io.Bytes.ofString("");
    }
}
#end