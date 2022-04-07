package;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
#if sys
import sys.FileSystem;
import sys.io.File;
import openfl.media.Sound;
#end
import flixel.FlxG;
import lime.utils.Assets;

/**
 * ...
 * @author KittyNya
 */

class Kyittz {
	private inline static var Audioext:String = #if sys "ogg"#else "mp3"#end;
	
	public static inline function getImage(Path){
		return "assets/images/" + Path;
	}
	
	public static inline function SparrowAtlas(Path:String){
		return FlxAtlasFrames.fromSparrow(loadImage(Path), loadText(Path, "xml"));
	}
	
	public static inline function JsonAtlas(Path:String){
		return FlxAtlasFrames.fromTexturePackerJson(loadImage(Path), loadText(Path, "json"));
	}
	
	public static function loadText(Path:String, ?Format:String = "txt"){
		if(exists(Path + "." + Format)){
		#if sys
			return File.getContent(Path + "." + Format);
		#else
			return Assets.getText(Path + "." + Format);
		#end
		}
		return null;
		
	}
	
	public static function loadAudio(Path:String, ?Audioext:String = ""){
		if (Audioext == ""){
			Audioext = Kyittz.Audioext;
		}
		if(exists(Path + "." + Audioext))
		#if sys
			return Sound.fromFile(Path + "." + Audioext);
		#else
			return Path + "." + Audioext;
		#end
		else
			FlxG.log.warn("failed audio loading!");
		return null;
	}
	
	public static function loadImage(Path:String){
		if(exists(Path + ".png")){
		#if sys
			var bitmap:BitmapData = BitmapData.fromFile(Path + ".png");
			var ret:FlxGraphic =  FlxGraphic.fromBitmapData(bitmap);
			return ret;
		#else
			return Path + ".png";
		#end
		}else{
			FlxG.log.warn("failed image loading!");
		}
		return null;
	}
	
	public static inline function exists(Path:String){
		#if sys
		return FileSystem.exists(Path);
		#else
		return Assets.exists(Path);
		#end
	}
	
}