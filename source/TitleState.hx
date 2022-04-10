package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import openfl.filters.ShaderFilter;

#if sys
import Sys;
#end

/**
 * ...
 * @author KittyNya
 */
class TitleState extends FlxTransitionableState {
	public var white = 0xFFa1f697;
	public var black = 0xFF110c22;
	public var font:String = "blocktopia"; 
	public var title:FlxText;
	public var curChoice:Int = 0;
	public var options:FlxTypedGroup<FlxText>;
	public var optionsString = ["New Game", "Continue", "Settings" #if !html5, "Exit" #end];
	public var pointer:FlxText;
	public var shader:ShitShader;
	public var shadertime:Float = 0;	
	public static var initsh:Bool = false;
	
	public function new() {
		super();
	}
	
	override public function create():Void
	{
		FlxG.save.bind("KittyNya", "JALS");
		if(!initsh){
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;
			FlxTransitionableState.defaultTransIn = new TransitionData(TILES , black, 1.6, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
			FlxTransitionableState.defaultTransOut = new TransitionData(TILES, black, 1.2, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
				
			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
			initsh = true;
		}
		super.create();
		FlxG.mouse.useSystemCursor = true;
		
		shader = new ShitShader();
		shader.iTime.value = [0];
		FlxG.camera.setFilters([new ShaderFilter(shader)]);
		
		pointer = new FlxText(0,0,0,">").setFormat("assets/fonts/" + font + ".ttf", 45, white);
		var whitegroung = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, white);
		add(whitegroung);
		title = new FlxText(0, 0, FlxG.width, "JUST A LITTLE SLEEP", 75);
		var blacgroung = new FlxSprite(0, title.y + (title.height / 4)).makeGraphic(FlxG.width, FlxG.height, black );
		add(blacgroung);
		title.setFormat("assets/fonts/" + font + ".ttf", 50, black,CENTER);//, CENTER,OUTLINE
		add(title);
		
		var titleunder = new FlxSprite(25, title.y + title.height + 10).makeGraphic(FlxG.width - (75 + 25), 8, white);
		add(titleunder);
		var titleunder2 = new FlxSprite(75, titleunder.y - 10).makeGraphic(FlxG.width - (25 + 75), 8, white);
		add(titleunder2);
		
		options = new FlxTypedGroup<FlxText>();
		for (i in 0...optionsString.length){
			var text = new FlxText(0, blacgroung.y + 50 + (i * 95), 0, optionsString[i], 55);
			text.setFormat("assets/fonts/" + font + ".ttf", 45, white, CENTER);
			text.screenCenter(X);
			options.add(text);
		}
		add(options);
		add(pointer);
		changeSelection(0);
		var botm = new FlxSprite(0, 0).makeGraphic(FlxG.width, Std.int(FlxG.height / 7), white);
		botm.y = FlxG.height - botm.height;
		add(botm);
		
		var titleunder22 = new FlxSprite(25, botm.y - 12).makeGraphic(FlxG.width - (75 + 25), 8, white);
		add(titleunder22);
		var titleunder23 = new FlxSprite(75, titleunder22.y - 10).makeGraphic(FlxG.width - (25 + 75), 8, white);
		add(titleunder23);
		
		FlxG.sound.playMusic(Kyittz.loadAudio("assets/music/main_theme"), 1, true);
		FlxG.sound.music.fadeIn(1.5, 0, 0.75);
		#if debug
		//FlxG.switchState(new PlayState());
		#end
	}
	
	override public function update(elapsed:Float){
		super.update(elapsed);
		shadertime += 1;
		shader.iTime.value = [Std.int(shadertime)];	
		#if html5
		if (shader.iTime.value[0] >= 100){
			shadertime = 0;
		}
		#end
		if (FlxG.keys.justPressed.UP){
			changeSelection( -1);
		}
		if (FlxG.keys.justPressed.DOWN){
			changeSelection( 1);
		}
		
		if (FlxG.keys.justPressed.ENTER){
			switch(options.members[curChoice].text){
				case "New Game":
					FlxG.save.data.curroom = "start";
					FlxG.save.data.inventory = [];
					FlxG.save.data.shnooze = 100;
					FlxG.save.data.day = 1;
					FlxG.save.flush();
					FlxG.sound.music.fadeOut(0.5, 0, function(Twe:FlxTween){FlxG.sound.music = null; });
					FlxG.switchState(new PlayState());
				case "Continue":
					FlxG.sound.music.fadeOut(0.5, 0, function(Twe:FlxTween){FlxG.sound.music = null; });
					FlxG.switchState(new PlayState());
			}	
		}
	}
	
	public function changeSelection(change:Int){
		curChoice += change;
		if (change != 0){
			FlxG.sound.play(Kyittz.loadAudio("assets/sounds/TypingSound", "wav"));
		}
		if (curChoice > optionsString.length - 1){
			curChoice = 0;
		}else if (curChoice < 0){
			curChoice = optionsString.length - 1;
		}
		trace(curChoice);
		pointer.y = options.members[curChoice].y;
		pointer.x = options.members[curChoice].x - (pointer.width + 10);
		FlxTween.tween(pointer, {x:pointer.x + 10}, 0.25, {ease: FlxEase.circIn});
		FlxTween.tween(pointer.offset, {x:5}, 0.2, {ease: FlxEase.circOut});
		
		FlxTween.tween(options.members[curChoice].offset, {x:5}, 0.2, {ease: FlxEase.circOut});
		for (i in 0...options.members.length){
			if (i != curChoice){
				options.members[i].x = options.members[0].x;
				FlxTween.tween(options.members[i].offset, {x:0}, 0.2, {ease: FlxEase.circIn});
			}
		}
	}
	
}