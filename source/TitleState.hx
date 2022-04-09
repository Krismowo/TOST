package;

import djFlixel.ui.FlxMenu;
import djFlixel.ui.menu.MPage;
import djFlixel.ui.menu.MPageData;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

#if sys
import Sys;
#end

/**
 * ...
 * @author KittyNya
 */
class TitleState extends FlxState {
	public var menu:FlxMenu;
	public var white = 0xFFa1f697;
	public var black = 0xFF110c22;
	public var font:String = "blocktopia"; 
	public var title:FlxText;
	public var curChoice:Int = 0;
	public var options:FlxTypedGroup<FlxText>;
	public var optionsString = ["New Game", "Continue", "Settings" #if !html5, "Exit" #end];
	public var pointer:FlxText;
	
	public function new() {
		super();
	}
	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.useSystemCursor = true;
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
			var text = new FlxText(0, blacgroung.y + 50 + (i * 65), 0, optionsString[i], 55);
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
	}
	
	override public function update(elapsed:Float){
		super.update(elapsed);
		if (FlxG.keys.justPressed.UP){
			changeSelection( -1);
		}
		if (FlxG.keys.justPressed.DOWN){
			changeSelection( 1);
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
		pointer.x = options.members[curChoice].x - pointer.width;
	}
	
	//FlxG.save.flush();
	//FlxG.switchState(new PlayState());
	
}