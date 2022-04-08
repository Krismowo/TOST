
// * THIS SHIT MULTICOLOR BUT ITS NOT SUPPOSED TO BE A PART OF THE GAME
// * ITS JUST MADE SO ITS LESS OF A PAIN TO MAKE THE JSON SHIT LOL
// * CREDITS 2 VIDYAGIRL (SELF-PROMO LOL)

package;

import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import texter.flixel.FlxInputTextRTL;
import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import openfl.text.TextField;
import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.ui.FlxInputText;
import haxe.Json;
import openfl.net.FileFilter;
import openfl.events.Event;
import openfl.net.FileReference;
import flixel.FlxState;

/// literally same typedefs in PlayState but i didnt realize and im too lazy to change it

typedef ChoiceItem = {
    var choiceName:String;
    var script:String;
}

typedef DialogueItem = {
    var roomItems:Array<Dynamic>;
    var choices:Array<ChoiceItem>;
    var roomText:String;
}

class LevelEditor extends FlxState {
    
    public var data:Array<DialogueItem> = [];
    public var index:Int = 0;

    public var curText:String;
    public var curChoiceName:String;
    public var curChoiceScript:String;
    public var curChoice:ChoiceItem;

    private static inline var WHITE:Int = 0xFFa1f697;
    private static inline var BLACK:Int = 0xFF110c22;

    private var uiGroup:FlxTypedGroup<FlxSprite>;

    var dumb:DumbText;

    public function new() {
        super();
    }

    var caret:FlxSprite;

    override function create() {
     
        uiGroup = new FlxTypedGroup<FlxSprite>();
        uiGroup.memberAdded.add(function(sprite:FlxSprite) {
            if (sprite.color == FlxColor.BLACK)
                sprite.color = BLACK;
            else if (sprite.color == FlxColor.WHITE)
                sprite.color = WHITE;
            sprite.scrollFactor.set();
        });

        add(uiGroup);

        createUI();

        caret = new FlxSprite(0, 0).makeGraphic(4, 16, FlxColor.BLACK);
        uiGroup.add(caret);

        super.create();
    }

    var focused:Bool = false;

    var caretTimer = .5;

    override function update(elapsed:Float) {
        
        //this happens another day
        //caretTimer -= elapsed;

        // if (caretTimer <= 0) {
        //     if (caret.visible)
        //         caret.visible = false;
        //     else
        //         caret.visible = true;
        //     caretTimer = .5;
        // }

        // caret.x = textInput.x + textInput.width + 8;
        // caret.y = textInput.y;
        
        curText = textInput.text;
        curChoiceName = choiceNameInput.text;
        curChoiceScript = scriptInput.text;

        var ctrl = FlxG.keys.pressed.CONTROL;

        if (ctrl && FlxG.keys.justPressed.L && !focused) {
            // load();
        } else if (ctrl && FlxG.keys.justPressed.S && !focused) {
            // save("nameHere");
        }

        if (!FlxG.mouse.overlaps(textShitBG) && (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight || FlxG.mouse.justPressedMiddle)) {
            focused = false;
        } else if (FlxG.mouse.overlaps(textShitBG) && FlxG.mouse.justPressed) {
            focused = true;
        }

        if (!focused && !dumb.stopped)  {
            dumb.stop();
        }
        if (focused && !dumb.playing) {
            dumb.resume();
        }

        if (FlxG.mouse.overlaps(group) && FlxG.mouse.justPressed) {
            group.forEach(function(tired) {
                if (FlxG.mouse.overlaps(tired)) {
                index = tired.ID;
                updateBullshit(index);
                }
            });
        }


        group.forEach(function(shit) {
            if (index == shit.ID) {
                shit.color = FlxColor.PURPLE;
            } else {
                shit.color = FlxColor.WHITE;
            }
        });

        fakeScroll(elapsed);

        super.update(elapsed);
    }

    var bottomBox:FlxSprite;
    var leftBox:FlxSprite;

    var choiceNameInput:FlxInputText;
    var scriptInput:FlxInputText;
    var textShitBG:FlxSprite;
    var textInput:FlxText;

    var addButton:FlxButtonPlus;
    var removeButton:FlxButtonPlus;

    var roomItemsInput:FlxInputText;
    var curRoomItems:Array<{name:String, id:String}>;

    
    var group:FlxTypedGroup<FlxText>;
    function createUI() {


        function uadd(sprite:FlxSprite)
            uiGroup.add(sprite);

        leftBox = new FlxSprite().makeGraphic(Std.int(FlxG.width / 4), Std.int(FlxG.height), BLACK);
        bottomBox = new FlxSprite().makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height / 4), BLACK);
        bottomBox.x = 0;
        bottomBox.y = FlxG.height - FlxG.height / 4;
        uadd(leftBox);
        uadd(bottomBox);

        var savebutton = new FlxButton(FlxG.width - 180, FlxG.height - 60, "Save", () -> {save('PutNameHere');});
        var loadbutton = new FlxButton(savebutton.x + 100, savebutton.y, "Load", load);

        uadd(savebutton);
        uadd(loadbutton);
        

        choiceNameInput = new FlxInputText(30, bottomBox.y + 40, 150, "", 16, BLACK);
        scriptInput = new FlxInputText(200, bottomBox.y + 40, 150, "", 16, BLACK);
        var border = new FlxSprite(leftBox.x + leftBox.width + 13, 13).makeGraphic(456, 416, BLACK);
        textShitBG = new FlxSprite(leftBox.x + leftBox.width + 15, 15).makeGraphic(460, 420);
        uadd(choiceNameInput);
        uadd(scriptInput);
        uadd(border);
        uadd(textShitBG);
        textInput = new FlxText(textShitBG.x + 15, textShitBG.y + 15, textShitBG.width - 30, "", 16);

        textInput.color = FlxColor.BLACK;
        uadd(textInput);

    
        var shitte = new FlxText(choiceNameInput.x, choiceNameInput.y - 20, 0, "Choice", 16);

        var troling = new FlxText(scriptInput.x, scriptInput.y - 20, "Script", 16);

        uadd(shitte);
    uadd(troling);

        var vSpace = 45;

        addButton = new FlxButtonPlus(choiceNameInput.x, choiceNameInput.y + vSpace, null, "Add", 150);

        var cool = new FlxButtonPlus(scriptInput.x, scriptInput.y + vSpace, null, "AddChoice", 150);


        removeButton = new FlxButtonPlus(cool.x+cool.width+30, scriptInput.y + vSpace, null, "Remove", 150); // fx position
        addButton.onClickCallback = function() {
            trace('addine');
            addItem({
                roomItems: [],
                choices: [{
                    choiceName: curChoiceName,
                    script: curChoiceScript
                }],
                roomText: curText
            });
            updateDialogueList();
        }

        cool.onClickCallback = function() {
            addAnotherChoice(curChoiceName, curChoiceScript);
            trace('moreChoice');
            updateDialogueList();
        }

        removeButton.onClickCallback = function() {
            trace('revoemvoe');
            data.remove(data[index]);
            if (index > data.length - 1)
                index--;
            updateDialogueList();
        }

        uadd(addButton);
        uadd(cool);
        uadd(removeButton);
        
        group = new FlxTypedGroup<FlxText>();

        add(group);

        makeDialogueList(group);

        dumb = new DumbText(textInput);
        
        dumb.keyShit = function() {
            data[index].roomText = textInput.text;
        }
    }

    function updateBullshit(index:Int) {
        textInput.dirty = true;
        choiceNameInput.dirty = true;
        scriptInput.dirty = true;
        textInput.text = data[index].roomText;
        choiceNameInput.text = "";
        scriptInput.text = "";
    }

    function updateDialogueList() {
        while (group.length > 0) {
            group.remove(group.members[0], true);
        }
        makeDialogueList(group);

        for (i in 0...group.members.length) {
            group.members[i].x = 30;
            group.members[i].y = 30;
            group.members[i].y += i * 50;
            group.members[i].text = 'Dialogue $i';
        }
    }

    // * USE UP AND ARROW KEYS WHEN NOT FOCUSED IN TEXT 2 SCROLL THRU THE LIST

    function fakeScroll(elapsed:Float) {
        if (FlxG.keys.justPressed.DOWN && !focused) {
            group.forEach(function(lol) {
                lol.y -= 50;
            });
        } else if (FlxG.keys.justPressed.UP && !focused) {
            group.forEach(function(xd) {
                xd.y += 50;
            });
        }
    }

    function makeDialogueList(spriteGroup:FlxTypedGroup<FlxText>) {

        var sg = group.members;
        trace('ref-mem');
        for (i in 0...data.length) {
            var selecty = new FlxText();
            selecty.size = 20;
            group.add(selecty);
        }

        for (i in 0...data.length) {
            if (sg != null && sg.length > 0) {
                if (i == 0 || sg[i-1] == null) {
                    sg[i].x = 30;
                    sg[i].y = 30;
                    sg[i].text == 'Dialogue $i';
                } else {
                    sg[i].x = sg[i-1].x;
                    sg[i].y = sg[i-1].y + sg[i-1].height + 15;
                    sg[i].text == 'Dialogue $i';
                }
            }
        }
            for (i in 0...data.length) {
                group.members[i].ID = i;
            }
    }

    function addItem(item:DialogueItem) {
        textInput.dirty = true;
        choiceNameInput.dirty = true;
        scriptInput.dirty = true;
        data.push(item);
        if (index == data.length - 2)
            index++;
        textInput.text = '';
        choiceNameInput.text = '';
        scriptInput.text = '';
        return item;
    }

    function addChoice(item:DialogueItem, name:String, script:String) {
        item.choices.push({
            choiceName: name,
            script: script
        });
        return item.choices[item.choices.length - 1];
    }

    function addAnotherChoice(name:String, script:String) {
        if (data[index].choices != null)
        addChoice(data[index], name, script);        
    }

    function save(name:String) {
        var fr:FileReference = new FileReference();
        fr.save(Json.stringify(data,"\t"), name + ".json");
    }

    function load() {
        var fr:FileReference = new FileReference();
        fr.addEventListener(Event.SELECT, onSelect);
        var filters:Array<FileFilter> = [
            new FileFilter("JSON files", "*.json")
        ];
        fr.browse(filters);
    }

    function onSelect(e:Event) {
        var fr:FileReference = cast(e.target, FileReference);
        fr.addEventListener(Event.COMPLETE, onComplete);
        fr.load(); // YOU FROGOT TBISFUNCTION DUMMY
        trace(fr.data, fr.name);
    }

    function onComplete(e:Event) {
        var fr:FileReference = cast(e.target, FileReference);
        fr.removeEventListener(Event.COMPLETE, onComplete);
        index = 0;
        data = cast Json.parse(fr.data.toString());
        updateDialogueList();
        updateBullshit(index);
    }
}
