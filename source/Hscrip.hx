package;
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
	public var tobekeptaftermovinglol
	public function new() {
		interp = new Interp();
		parser = new Parser();
	}
	
	public function loadScript(Path:String){
		interp.execute(parser.parseString(#if sys File.getContent#else Assets.getText#end(Path + ".hx") , "hx");
	}
	
	public function set(variname:String, vari:Dynamic){
		interp.variables.set(variname, vari);
	}
	
	public function loadFunc(FuncName:String){
		if (interp.variables.exists(FuncName)){
			var func = interp.variables.get(FuncName);
			func();
		}
	}
}