package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.FlxG;

/**
 * ...
 * @author KittyNya
 */
class InitState extends FlxTransitionableState {
	public var white = 0xFFa1f697;
	public var black = 0xFF110c22;
	public function new() {
		super();
		
	}
	
	override public function create(){
		super.create();
		FlxG.switchState(new TitleState()); //DUNNO WHAT ANY OF DIS MEANS BUT WHAYTEVER I GOT IT WORKIN WOOO
	}
	
}