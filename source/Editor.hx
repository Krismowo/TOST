package;

import flixel.FlxState;
import flixel.FlxG;

/**
 * ...
 * @author KittyNya
 */
class Editor extends FlxState {
	public var room = "";
	//public var editorbox;
	public function new(curroomlmao:String) {
		super();
		room = curroomlmao;
	}
	
	override public function update(elapsed:Float){
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE){
			FlxG.switchState(new PlayState());
		}
	}
	
}