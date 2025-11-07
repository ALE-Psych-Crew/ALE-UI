package ale.ui;

import flixel.input.keyboard.FlxKey;

import ale.ui.ALEMouseSpriteGroup;
import ale.ui.ALEUIUtils;

import openfl.ui.Mouse;

typedef CheckPosition = {
	result:Bool,
	position:Int
}

/**
 * TODO:
 * - Fix Erase
 * - Optimize (?)
 */

class ALEInputText extends ALEMouseSpriteGroup
{
	var theWidth:Float;
	var theHeight:Float;

	var labelX:Float;

	public var bg:FlxSprite;

	public var searchLabel:FlxText;
	public var label:FlxText;

	public var cursor:FlxSprite;
	var cursorTimer:Float = 0;

	public var curSelected(default, set):Int;
	function set_curSelected(val:Int):Int
	{
		curSelected = val;

		updateCursorPos();

		return curSelected;
	}

	public var isTyping(default, set):Bool;
	function set_isTyping(val:Bool):Bool
	{
		isTyping = val;

		cursor.visible = isTyping;

		cursorTimer = 0;

		return isTyping;
	}

	public var value(default, set):String;
	function set_value(val:String):String
	{
		value = val;

		label.text = value;

		return value;
	}

	public function new(?x:Float, ?y:Float, ?width:String, ?height:String, ?defValue:String)
	{
		super(x, y);

		theWidth = Math.floor(width ?? (ALEUIUtils.OBJECT_SIZE * 6));
		theHeight = Math.floor(width ?? ALEUIUtils.OBJECT_SIZE);

		labelX = theWidth / 36;

		bg = new FlxSprite();
		bg.pixels = ALEUIUtils.uiBitmap(theWidth, theHeight, false, -25);
		add(bg);

		searchLabel = new FlxText(labelX, 0, 0, '', Math.floor(Math.min(theWidth, theHeight) / 1.5));
		searchLabel.alpha = 0.5;
		searchLabel.font = ALEUIUtils.FONT;
		searchLabel.y = theHeight / 2 - searchLabel.height / 2;
		add(searchLabel);

		label = new FlxText(labelX, 0, 0, '', Math.floor(Math.min(theWidth, theHeight) / 1.5));
		label.font = ALEUIUtils.FONT;
		label.y = theHeight / 2 - label.height / 2;
		add(label);

		cursor = new FlxSprite(labelX).makeGraphic(Math.floor(theWidth * 0.0125), Math.floor(theHeight * 0.65));
		cursor.y = theHeight / 2 - cursor.height / 2;
		add(cursor);
		cursor.alpha = 0.75;

		value = defValue ?? '';

		curSelected = value.length;

		isTyping = true;
		
        FlxG.stage.addEventListener('keyDown', onKeyDown, false, 1);
	}

	override function update(elapsed:Float):Float
	{
		if (isTyping)
		{
			if (cursorTimer < 0.5)
			{
				cursorTimer += elapsed;
			} else {
				cursor.visible = !cursor.visible;

				cursorTimer = 0;
			}
		}

		if (FlxG.mouse.justPressed)
		{
			if (overlaped)
			{
				if (!isTyping)
					isTyping = true;
			} else {
				isTyping = false;
			}
		}

		super.update(elapsed);
	}

    override function destroy()
    {
        FlxG.stage.removeEventListener('keyDown', onKeyDown, false);

        isTyping = false;

        super.destroy();
    }

	override function overlapCallbackHandler(isOver:Bool)
	{
		Mouse.cursor = isOver ? 'ibeam' : 'arrow';

		super.overlapCallbackHandler(isOver);
	}

    function onKeyDown(e:KeyboardEvent):Void
    {
        if (!isTyping)
            return;

		var alphaNumericReg:EReg = ~/[\w]/;
		var spaceReg:EReg = ~/[\s]/;

        final key:FlxKey = e.keyCode;

		var toAdd:String = null;

        switch (key)
        {
            case FlxKey.SHIFT, FlxKey.CONTROL, FlxKey.BACKSLASH, FlxKey.ALT:
            
            case FlxKey.ENTER, FlxKey.ESCAPE:
				isTyping = false;

            case FlxKey.TAB:

            case FlxKey.HOME:
				curSelected = 0;

            case FlxKey.END:
				curSelected = value.length;

            case FlxKey.LEFT:
				var toChange:Int = 1;

				if (e.ctrlKey)
				{
					if (spaceReg.match(value.charAt(curSelected - 1)))
						while (curSelected - toChange >= 0 && spaceReg.match(value.charAt(curSelected - toChange)))
							toChange++;

					while (curSelected - toChange >= 0 && alphaNumericReg.match(value.charAt(curSelected - toChange)))
						toChange++;

					toChange--;
				}

				curSelected = Math.max(curSelected - toChange, 0);

            case FlxKey.RIGHT:
				var toChange:Int = 1;

				if (e.ctrlKey)
				{
					if (spaceReg.match(value.charAt(curSelected + 1)))
						while (curSelected + toChange >= 0 && spaceReg.match(value.charAt(curSelected + toChange)))
							toChange++;

					while (curSelected + toChange <= value.length && alphaNumericReg.match(value.charAt(curSelected + toChange)))
						toChange++;
				}

				curSelected = Math.min(curSelected + toChange, value.length);

            case FlxKey.BACKSPACE:
				var toChange:Int = 1;

				if (e.ctrlKey)
				{
					var isSpace:Bool = spaceReg.match(value.charAt(curSelected - 1));

					if (isSpace)
						while (curSelected - toChange >= 0 && spaceReg.match(value.charAt(curSelected - toChange)))
							toChange++;

					if ((isSpace && !spaceReg.match(value.charAt(curSelected - 2))) || !isSpace)
						while (curSelected - toChange >= 0 && alphaNumericReg.match(value.charAt(curSelected - toChange)))
							toChange++;

					toChange--;
				}

				value = value.substring(0, curSelected - toChange) + value.substring(curSelected);

				curSelected = Math.max(curSelected - toChange, 0);

            case FlxKey.DELETE:
				var toChange:Int = 1;

				if (e.ctrlKey)
				{
					var isSpace:Bool = spaceReg.match(value.charAt(curSelected));

					if (isSpace)
						while (curSelected + toChange >= 0 && spaceReg.match(value.charAt(curSelected + toChange)))
							toChange++;

					if ((isSpace && !spaceReg.match(value.charAt(curSelected + 1))) || !isSpace)
						while (curSelected + toChange <= value.length && alphaNumericReg.match(value.charAt(curSelected + toChange)))
							toChange++;
				}

				value = value.substring(0, curSelected) + value.substring(curSelected + toChange);

            case FlxKey.SPACE:
				toAdd = ' ';

            default:
				toAdd = CoolUtil.fromCharCode(e.charCode);
        }

		if (toAdd != null)
		{
			value = value.substring(0, curSelected) + toAdd + value.substring(curSelected);

			curSelected = curSelected + 1;
		}
    }

	function updateCursorPos()
	{
		cursor.visible = true;

		cursorTimer = 0;

		var bounds = label.textField.getCharBoundaries(curSelected - 1);

		cursor.x = this.x + labelX + (bounds == null ? 0 : bounds.x + bounds.width) - 1;
	}
}