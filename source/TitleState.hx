package;

import flixel.FlxState;
import flixel.FlxG;

/**
 * ...
 * @author KittyNya
 */
class TitleState extends FlxState {

	public function new() {
		super();
	}
	
	override public function create():Void
	{
		super.create();
		FlxG.save.bind("Jals", "Kitty");
		FlxG.mouse.useSystemCursor = true;
		FlxG.switchState(new PlayState());
	}
	
}