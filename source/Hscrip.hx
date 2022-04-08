package;
import flixel.util.FlxTimer;
import hscript.Interp;
import hscript.Parser;
import lime.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

/**
 * ...
 * @author KittyNya
 */
class Hscrip {
	public var parser:Parser;
	public var interp:Interp;
	public function new(self:Dynamic) {
		interp = new Interp();
		parser = new Parser();
		set("self", self);
		set("Timer", Timer);
	}
	
	public function Timer(Time:Int, callback:Dynamic){
		new FlxTimer().start(Time, callback);
	}
	
	public function loadScript(Path:String){
		interp.execute(parser.parseString(#if sys File.getContent#else Assets.getText#end(Path + ".hx") , "hx"));
	}
	
	public function set(variname:String, vari:Dynamic){
		interp.variables.set(variname, vari);
	}
	
	public function get(variname:String){
		if (interp.variables.exists(variname)){
			return interp.variables.get(variname);
		}
		return null;
	}
	
	public function loadFunc(FuncName:String){
		if (interp.variables.exists(FuncName)){
			var func = get(FuncName);
			func();
		}
	}
}