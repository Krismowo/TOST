package;

import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author KittyNya
 */
class RestartingLol extends FlxSubState {
	var bgshizz:FlxSprite;
	var funnymunb:Float = 0;
	var tweentimer:Float = 30;
	public function new() {
		super(FlxColor.TRANSPARENT);
		bgshizz = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000035);
		bgshizz.alpha = 0;
		add(bgshizz);
	}
	
	override public function update(elapsed:Float){
		super.update(elapsed); 
		//(-testnumb / 2.05) + (thing.height / 2); spesh code lol
		//var doit = (testnumb > tweentimer);
		var doit = (funnymunb > tweentimer);
		if (doit){
			bgshizz.alpha = (funnymunb / 85);
			trace(funnymunb / 85);
			if (funnymunb / 85 >= 1){
				FlxG.switchState(new PlayState());
			}
			tweentimer += funnymunb;
		}
		funnymunb += 1;
	}
	
}