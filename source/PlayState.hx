package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxColor;
import djFlixel.gfx.FilterFader;
import flixel.addons.text.FlxTypeText;
import haxe.Json;
import lime.utils.Assets;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

typedef GameDataLmao = {
	var roomItems:Array<String>;
	var choices:Array<Choice>;
	var roomText:String;
	var roomTextSpeed:Float;
}

typedef Choice = {
	var script:String;
	var choiceName:String;
}

class PlayState extends FlxState
{
	public var Timer:Float = 45;
	public var timerlol:FlxTimer;
	public var DaGaem:GameDataLmao;
	public var uishiz:FlxTypedSpriteGroup<FlxSprite>;
	public var curroom:String = "start";
	public var savebtn:FlxText;
	public var loadbtn:FlxText;
	public var exitbtn:FlxText;
	public var buttons:FlxTypedSpriteGroup<FlxText>; 
	public var font:String = "blocktopia"; 
	public var GameText:FlxTypeText;
	public var inventory:Array<String> = [];
	public var white = 0xFFa1f697;
	public var black = 0xFF110c22;
	override public function create():Void
	{
		super.create();
		if (FlxG.save.data.curroom == null){
			FlxG.save.data.curroom = curroom;
			FlxG.save.data.inventory = inventory;
			FlxG.save.flush();
		}
		set_bgColor(black);
		uishiz = new FlxTypedSpriteGroup<FlxSprite>();
		add(uishiz);
		
		buttons = new FlxTypedSpriteGroup<FlxText>();
		add(buttons);
		
		var bottom = new FlxSprite(0, 0).makeGraphic(FlxG.width, Std.int(FlxG.height / 4 - 75),white);
		bottom.y = FlxG.height - bottom.height;
		uishiz.add(bottom);
		
		var btnoffset = 25;
		
		savebtn = new FlxText(bottom.y / 2, 0, 0, "SAVE", 355);
		savebtn.setFormat("assets/fonts/" + font + ".ttf", 24, black);
		savebtn.y = bottom.y + (bottom.height / 2) - (savebtn.height / 2);
		savebtn.updateHitbox();
		buttons.add(savebtn);
		
		loadbtn = new FlxText(bottom.y / 2, 0, 0, "LOAD", 35);
		loadbtn.setFormat( "assets/fonts/" + font + ".ttf", 24, black);
		loadbtn.y = bottom.y + (bottom.height / 2) - (savebtn.height / 2);
		loadbtn.updateHitbox();
		buttons.add(loadbtn);
		
		exitbtn = new FlxText(bottom.y / 2, 0, 0, "EXIT", 35);
		exitbtn.setFormat( "assets/fonts/" + font + ".ttf", 24, black);
		exitbtn.y = bottom.y + (bottom.height / 2) - (savebtn.height / 2);
		exitbtn.updateHitbox();
		buttons.add(exitbtn);
		
		Timer = FlxG.random.float(50, 75);
		timerlol = new FlxTimer().start(Timer, function(tim:FlxTimer){
			trace("mk restarting...");
			openSubState(new RestartingLol());
		});
		var thn = [3, 2, 1];
		for (i in 0...buttons.members.length){
			buttons.members[i].x = ((FlxG.width / 5) / i + 1) + btnoffset;
		}
		//exitbtn.x -= 215;
		savebtn.x = 25;
		savebtn.y = exitbtn.y;
		
		GameText = new FlxTypeText(FlxG.width / 2 - 225, 0, Std.int(FlxG.width / 2) + 225, "", 28);
		GameText.setFormat("assets/fonts/" + font + ".ttf", 28, white);
		add(GameText);
		GameText.resetText(loadtextshiz());
		GameText.start(DaGaem.roomTextSpeed, true);
		trace(GameText.text);
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		#if debug
		if (FlxG.keys.justPressed.L){
			trace("mk restarting...");
			openSubState(new RestartingLol());
		}
		#end
		for (i in 0...buttons.members.length){
			if (FlxG.mouse.overlaps(buttons.members[i])){
				FlxTween.tween(buttons.members[i].offset, {y: 7}, 0.15);
			}else{
				FlxTween.tween(buttons.members[i].offset, {y: 0}, 0.15);
			}
		}
		if (FlxG.mouse.justPressed ){
			for (i in 0...buttons.members.length){
				if (FlxG.mouse.overlaps(buttons.members[i])){
					switch(buttons.members[i].text){
						default:
							trace("mk");
					}
				}
			}
		}
	}
	
	public function loadtextshiz(){
		var rawjson = #if sys File.getContent#else Assets.getText#end ("assets/story/" + curroom + ".json");
		var cookedjson:GameDataLmao = cast Json.parse(rawjson); 
		DaGaem = cookedjson;
		return cookedjson.roomText;
	}
}