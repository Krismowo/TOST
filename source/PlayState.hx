package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroupIterator;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
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
using StringTools;

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
	public var choices:FlxTypedGroup<FlxTypeText>;
	public var choicemap:Map<String, String>;
	public var left:FlxSprite;
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
		
		
		var btnoffset = 300;
		
		loadbtn = new FlxText(10, 0, 0, "LOAD", 40);
		loadbtn.setFormat( "assets/fonts/" + font + ".ttf", 30, black);
		loadbtn.y = bottom.y + (bottom.height / 2) - (loadbtn.height / 2);
		loadbtn.updateHitbox();
		buttons.add(loadbtn);
		
		exitbtn = new FlxText(80, 0, 0, "EXIT", 40);
		exitbtn.setFormat( "assets/fonts/" + font + ".ttf", 30, black);
		exitbtn.y = bottom.y + (bottom.height / 2) - (loadbtn.height / 2);
		exitbtn.updateHitbox();
		buttons.add(exitbtn);
		
		GameText = new FlxTypeText(FlxG.width / 2 - 225, 0, Std.int(FlxG.width / 2) + 225, "", 28);
		GameText.setFormat("assets/fonts/" + font + ".ttf", 32, white);
		add(GameText);
		GameText.resetText(loadtextshiz());
		GameText.sounds = [];
		GameText.sounds.push(new FlxSound().loadEmbedded("assets/sounds/TypingSound.wav", false));
		GameText.sounds[0].volume = 0.5;
		//GameText.sounds.push(new FlxSound().loadEmbedded("assets/sounds/TypingSound2.wav",false));
		//GameText.sounds.push(new FlxSound().loadEmbedded("assets/sounds/TypingSound3.wav",false));
		GameText.start(0.04, true);
		trace(GameText.text);
		
		left = new FlxSprite(GameText.x, 0).makeGraphic(Std.int(FlxG.width / 2 - 225), FlxG.height, white);
		left.x -= left.width + 5;
		loadchoices(); 
		//FlxG.sound.playMusic("assets/music/Inst.ogg", 0.45, true);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		#if debug
		if (FlxG.keys.justPressed.TWO){
			trace("mk restarting...");
			openSubState(new RestartingLol());
		}
		if (FlxG.keys.justPressed.ONE){
			FlxG.switchState(new Editor(curroom));
		}
		#end
		for (i in 0...choices.length){
			if (FlxG.mouse.overlaps(choices.members[i])){
				if(FlxG.mouse.justPressed){
					var checkspeshthing = [];
					@:privateAccess{
						checkspeshthing = choicemap.get(choices.members[i]._finalText).split(" ");
						trace(checkspeshthing);
					}
					if (checkspeshthing.length < 1){
						var script:Hscrip = new Hscrip(this);
						script.set("goto", function(room:String){
							curroom = room;
							loadchoices();
							GameText.resetText(loadtextshiz());
							GameText.sounds = [];
							GameText.sounds.push(new FlxSound().loadEmbedded("assets/sounds/TypingSound.wav", false));
							GameText.sounds[0].volume = 0.5;
							GameText.start(0.04, true);
						});
						script.loadScript("assets/scripts" + checkspeshthing[0]);
					}else{
						switch(checkspeshthing[0].trim()){
							case "goto":
								curroom = checkspeshthing[1].trim();
								loadchoices();
								GameText.resetText(loadtextshiz());
								GameText.sounds = [];
								GameText.sounds.push(new FlxSound().loadEmbedded("assets/sounds/TypingSound.wav", false));
								GameText.sounds[0].volume = 0.5;
								GameText.start(0.04, true);
								trace(GameText.text);
						}
					}
				}
			}
		}
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
	
	public function loadchoices(){
		if (choices != null ) {
			remove(choices);
			choicemap = null;
		}
		choicemap = new Map<String, String>();
		choices = new FlxTypedGroup<FlxTypeText>();
		for (i in 0...DaGaem.choices.length){                                                                      
			var text = new FlxTypeText(5, 5, Std.int(left.width), DaGaem.choices[i].choiceName, 23);
			text.setFormat("assets/fonts/" + font + ".ttf", 30, white);
			if (i - 1 >= 0){
				trace("yesh!!!!"); //if anyone sees this, my oc is 19 (nobody will need this info lmfao)
				text.y = (choices.members[i - 1].y + choices.members[i - 1].height) + 5;
			}
			text.resetText(DaGaem.choices[i].choiceName);
			text.start(0.2, true);
			choicemap.set(DaGaem.choices[i].choiceName, DaGaem.choices[i].script);
			choices.add(text);
		}
		add(choices);
	}
	
	public function loadtextshiz(){
		var rawjson = #if sys File.getContent#else Assets.getText#end ("assets/story/" + curroom + ".json");
		var cookedjson:GameDataLmao = cast Json.parse(rawjson); 
		DaGaem = cookedjson;
		return cookedjson.roomText;
	}
}