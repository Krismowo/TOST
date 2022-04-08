package;

import flixel.input.keyboard.FlxKey;
import openfl.ui.Keyboard;
import flixel.text.FlxText;
import openfl.events.KeyboardEvent;
import flixel.FlxG;

class DumbText {
    
    public var attachedText:FlxText;
    public var playing:Bool = true;
    public var stopped:Bool = false;

    public function new(attachedSprite:FlxText) {
        attachedText = attachedSprite;
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    public function stop(?detach:Bool = false) {
        FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        this.attachedText = detach ? null : this.attachedText; // how does the haxe compiler even parse this?
        stopped = true;
        playing = false;
    }

    public function resume() {
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stopped = false;
        playing = true;
    }

    public function attach(flxText:FlxText) {
        this.attachedText = flxText;
    }

    public var keyShit:Void->Void;

    function onKeyDown(ke:KeyboardEvent) {
        var char:String = "";
            if (!ke.controlKey) {
            if (ke.charCode != Keyboard.BACKSPACE  || ke.charCode != 127) {
                char = String.fromCharCode(ke.charCode);
                if (ke.charCode == Keyboard.SPACE)
                    char = " ";
                if (ke.charCode == Keyboard.BACKSPACE || ke.charCode == 127) {
                    
                    attachedText.text = attachedText.text.substr(0, attachedText.text.length - 1);
                }
                if (ke.charCode != Keyboard.SHIFT && ke.charCode != 0 && !(ke.charCode == Keyboard.BACKSPACE || ke.charCode == 127))
                    attachedText.text += char;
                
            }
        }

            keyShit();
        
    }
}