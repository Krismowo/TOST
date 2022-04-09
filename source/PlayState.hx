package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroupIterator;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
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
import openfl.filters.ShaderFilter;
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
	public var barout:FlxSprite;
	public var bottom:FlxSprite;
	public var shader:ShitShader;
	public var shadertime:Float;
	public var lastsong = -1;
	public var songs:Array<String> = ["Un Countable Time", "Goodnight"];
	public var shnoozeBar:FlxBar;
	public var shnoozability:Float = 100;
	public var tiredtext:FlxText;
	public var carlocation = "";
	public var day:Int = 1;
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.useSystemCursor = true;
		shader = new ShitShader();
		shader.iTime.value = [0];
		FlxG.camera.setFilters([new ShaderFilter(shader)]);
		
		set_bgColor(black);
		uishiz = new FlxTypedSpriteGroup<FlxSprite>();
		add(uishiz);
		
		buttons = new FlxTypedSpriteGroup<FlxText>();
		add(buttons);
		
		bottom = new FlxSprite(0, 0).makeGraphic(FlxG.width, Std.int(FlxG.height / 4 - 95),white);
		bottom.y = FlxG.height - bottom.height;
		uishiz.add(bottom);
		
		
		var btnoffset = 300;
		
		loadbtn = new FlxText(10, 0, 0, "LOAD", 28);
		loadbtn.setFormat( "assets/fonts/" + font + ".ttf", 28, black);
		loadbtn.y = bottom.y + (bottom.height / 2) - (loadbtn.height / 2);
		loadbtn.updateHitbox();
		buttons.add(loadbtn);
		
		exitbtn = new FlxText(100, 0, 0, "EXIT", 28);
		exitbtn.setFormat( "assets/fonts/" + font + ".ttf", 28, black);
		exitbtn.y = bottom.y + (bottom.height / 2) - (loadbtn.height / 2);
		exitbtn.updateHitbox();
		buttons.add(exitbtn);
		
		GameText = new FlxTypeText(0, 0, FlxG.width - 45, "", 28);
		GameText.setFormat("assets/fonts/" + font + ".ttf", 32, white, CENTER);
		add(GameText);
		
		barout = new FlxSprite(FlxG.width - 50, 10).makeGraphic(35, Std.int(FlxG.height - (bottom.height + 20)), white);
		add(barout);
		shnoozeBar = new FlxBar(barout.x + 5, barout.y + 5, BOTTOM_TO_TOP, Std.int(barout.width - 10), Std.int(barout.height -10), this, "shnoozability",  0, 100 , false);
		shnoozeBar.createFilledBar(white, black);
		add(shnoozeBar);
		
		loadgame();
		trace(shnoozability);
		tiredtext = new FlxText(barout.x, barout.y + (barout.height / 2), 20, "SLEEPLESNESS", 20);
		tiredtext.setFormat( "assets/fonts/" + font + ".ttf", 28, white);
		tiredtext.y -= (tiredtext.height / 2);
		tiredtext.x -= (tiredtext.width + 5);
		add(tiredtext);
		GameText.width -= (tiredtext.width + 5);
		FlxG.sound.music = new FlxSound();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		shadertime += 1;
		if (shnoozability < 1){
			openSubState(new RestartingLol());
		}
		//var funny:Float = Std.int(shadertime);
		shader.iTime.value = [Std.int(shadertime)];	
		#if html5
		if (shader.iTime.value[0] >= 100){
			shadertime = 0;
		}
		#end
		if (FlxG.sound.music.playing){
			if ((FlxG.sound.music.length / 1000) - (FlxG.sound.music.time / 1000) <= 1.5 && FlxG.sound.music.volume >= 0.75){
				FlxG.sound.music.fadeOut(1.5);
			}
		}else{
			if (Std.int(shadertime) % 1000 == 0){
				if (FlxG.random.bool(1)){
					FlxG.sound.playMusic(Kyittz.loadAudio("assets/music/" + songs[FlxG.random.int(0, songs.length - 1,[lastsong])]), 0.75, false);
					FlxG.sound.music.fadeIn( 1.5, 0, 0.75);
				}
			}
		}
		#if debug
		if (FlxG.keys.justPressed.Q){
			shnoozability += 2;
		}
		if (FlxG.keys.justPressed.A){
			shnoozability -= 2;	
		}
		if (FlxG.keys.justPressed.TWO){
			trace("mk restarting...");
			openSubState(new RestartingLol());
		}
		if (FlxG.keys.justPressed.ONE){
			FlxG.switchState(new LevelEditor());
		}
		if (FlxG.keys.justPressed.THREE){
			FlxG.save.data.curroom = "start";
			FlxG.save.data.inventory = [];
			FlxG.save.data.shnooze = 100;
			FlxG.save.data.day = 1;
			FlxG.save.flush();
			loadgame();
		}
		#end
		if (choices != null ){
			if(choices.members.length > 0){
				for (i in 0...choices.members.length){
					if (FlxG.mouse.justPressed && choices.members[i] != null ){
						if (FlxG.mouse.overlaps(choices.members[i])){
							var sleeptake:Float = 0;
							var checkspeshthing = [];
							@:privateAccess{
								trace(choices.members[i]._finalText);
								checkspeshthing = choicemap.get(choices.members[i]._finalText).split(" ");
								trace(checkspeshthing);
							}
							sleeptake = 0.5;
							switch(checkspeshthing[0]){
								case "goto":
									gotoroom(checkspeshthing[1]);
								case "PutOnJacket":
									if (!inventory.contains("jacket")){
										inventory.push("jacket");
										gotoroom("Put_OnJacket_NO");
									}else{
										gotoroom("Put_OnJacket_AO");
									}
								default:
									trace("oops you dont got anything that exists in there!!!");
									//var script:Hscrip = new Hscrip(this);
									//script.set("sleeptake", sleeptake);
									//script.set("stuffarr", checkspeshthing);
									//script.loadScript("assets/scripts/" + checkspeshthing[0]);
									//sleeptake = script.get("sleeptake");
							}
							if (!Math.isNaN(sleeptake)){
								shnoozability -= sleeptake;
							}
							if (shnoozability > 100){
								shnoozability = 100;
							}else if (shnoozability < 0){
								shnoozability = 0;
							}
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
						case "LOAD":
							trace("mkmkmkmk");
							loadgame();
						case "EXIT":
							FlxG.switchState(new TitleState());
						default:
							trace("mk");
					}
				}
			}
		}
	}
	
	public function loadgame(){
		if (FlxG.save.data.day != null){
			day = FlxG.save.data.day;
		}else{
			day = 1;
		}
		if (FlxG.save.data.curroom != null ){
			gotoroom(FlxG.save.data.curroom);
		}else{
			gotoroom("start");
		}
		if(FlxG.save.data.shnooze != null){
			shnoozability = FlxG.save.data.shnooze;
		}else{
			shnoozability = 100;
		}
		if (FlxG.save.data.inventory != null ){
			inventory = FlxG.save.data.inventory;
		}else{
			inventory = [];
		}
		if(FlxG.save.data.carloq != null){
			carlocation = FlxG.save.data.carloq;
		}else{
			carlocation = "";
		}
	}
	
	public function savegame(){
		FlxG.save.data.curroom = curroom;
		FlxG.save.data.inventory = inventory;
		FlxG.save.data.shnooze = shnoozability;
		FlxG.save.data.carloq = carlocation;
		FlxG.save.data.day = day;
		FlxG.save.flush();
	}
	
	public function loadchoices(){
		remove(choices);
		choicemap = null;
		
		choicemap = new Map<String, String>();
		choices = new FlxTypedGroup<FlxTypeText>();
		for (i in 0...DaGaem.choices.length){                                                                      
			var text = new FlxTypeText(5, bottom.y, 0, DaGaem.choices[i].choiceName, 20);
			text.ID = i;
			text.y -= (text.height + 7);
			text.setFormat("assets/fonts/" + font + ".ttf", 30, white);
			if (i - 1 > 0){
				trace("yesh!!!!"); //if anyone sees this, my oc is 19 (nobody will need this info lmfao)
				text.x = (choices.members[i - 1].x + choices.members[i - 1].width) + 5;
			}
			text.resetText(DaGaem.choices[i].choiceName);
			text.start(0.00000000001, true);
			@:privateAccess{
				choicemap.set(text._finalText, DaGaem.choices[i].script);
			}
			choices.add(text);
		}
		add(choices);
	}
	
	public function gotoroom(room:String){
		if(choices != null){
			for (i in choices.members){
				i.visible = false;
			}
		}
		curroom = room;
		loadRoom();
		GameText.sounds = [];
		GameText.sounds.push(new FlxSound().loadEmbedded(Kyittz.loadAudio("assets/sounds/TypingSound", "wav"), false));
		GameText.sounds[0].volume = 0.15;
		GameText.resetText(DaGaem.roomText);
		GameText.start(0.056, true); 
		GameText.completeCallback = function(){
			loadchoices();
			choices.members[choices.members.length - 1].completeCallback = function(){
				for (i in 0...choices.members.length){
					choices.members[i].visible = true;
					if(i > 0)
						choices.members[i].x = (choices.members[i - 1].x + choices.members[i - 1].width) + 12;
				}
				for (i in choices.members){
					i.start(0.04, true);
				}
			}
		}
	}
	
	public function loadRoom(){
		var rawjson = #if sys File.getContent#else Assets.getText#end ("assets/story/day" + day + "/" + curroom + ".json");
		var cookedjson:GameDataLmao = cast Json.parse(rawjson); 
		DaGaem = cookedjson;
	}
}