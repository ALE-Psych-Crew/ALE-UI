package ale.ui;

import flixel.input.keyboard.FlxKey;
import flixel.math.FlxRect;

import lime.system.Clipboard;

import openfl.ui.Mouse;

import ale.ui.ALEMouseSpriteGroup;
import ale.ui.ALEUIUtils;

using StringTools;

typedef CheckPosition = {
	result:Bool,
	position:Int
}

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

	public var focusCallback:Bool -> Void;

	public var typeCallback:String -> Void;

	public var isTyping(default, set):Bool;
	function set_isTyping(val:Bool):Bool
	{
		isTyping = val;

		cursor.visible = isTyping;

		cursorTimer = 0;

		if (focusCallback != null)
			focusCallback(isTyping);

		return isTyping;
	}

	public var value(default, set):String;
	function set_value(val:String):String
	{
		value = val;

		label.text = value;

		updateSearch();

		return value;
	}

	public var toSearch(default, set):Array<String>;
	function set_toSearch(val:Array<String>):Array<String>
	{
		toSearch = val;

		updateSearch();

		return toSearch;
	}

	public var searchDefault:String = '';
	function set_searchDefault(val:String):String
	{
		searchDefault = val;

		updateSearch();

		return searchDefault;
	}

	public var searchResult:String = '';

	public var filter:EReg;

	public function new(?x:Float, ?y:Float, ?search:Array<String>, ?width:String, ?height:String, ?searchDef:String, ?defValue:String)
	{
		super(x, y);

		theWidth = Math.floor(width ?? (ALEUIUtils.OBJECT_SIZE * 6));
		theHeight = Math.floor(height ?? ALEUIUtils.OBJECT_SIZE);

		labelX = Math.max(1, theWidth / 36);

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

		toSearch = search;
		
		searchDefault = searchDef;

		updateSearch();
		
        FlxG.stage.addEventListener('keyDown', onKeyDown, false, 1);
	}

	override function uiUpdate(elapsed:Float):Float
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
		
		super.uiUpdate(elapsed);
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

		var punctReg:EReg = ~/[\.\,\;\:\¡\!\¿\?\\"'\(\)\[\]\{\}\-\—\…]/;
		var alphaNumericReg:EReg = ~/[\w]/;
		var spaceReg:EReg = ~/[\s]/;

		var printReg:EReg = ~/[\x20-\x7E]/;

		var regs:Array<EReg> = [punctReg, spaceReg, alphaNumericReg];

        final key:FlxKey = e.keyCode;

		var toAdd:String = null;

        switch (key)
        {
            case FlxKey.SHIFT, FlxKey.CONTROL, FlxKey.BACKSLASH, FlxKey.ALT:
            
            case FlxKey.ENTER, FlxKey.ESCAPE:
				isTyping = false;

            case FlxKey.TAB:
				if (searchResult.length > 0)
				{
					value = searchResult;

					curSelected = value.length;
				}

            case FlxKey.HOME:
				curSelected = 0;

            case FlxKey.END:
				curSelected = value.length;

            case FlxKey.LEFT:
				curSelected = Math.max(curSelected - (e.ctrlKey ? typedCharacterRegex(true, regs) - 1 : 1), 0);

            case FlxKey.RIGHT:
				curSelected = Math.min(curSelected + (e.ctrlKey ? typedCharacterRegex(false, regs) : 1), value.length);

            case FlxKey.BACKSPACE:
				var toChange:Int = e.ctrlKey ? typedCharacterRegex(true, regs) - 1 :  1;

				value = value.substring(0, curSelected - toChange) + value.substring(curSelected);

				curSelected = Math.max(curSelected - toChange, 0);

            case FlxKey.DELETE:
				value = value.substring(0, curSelected) + value.substring(curSelected + (e.ctrlKey ? typedCharacterRegex(false, regs) : 1));

            case FlxKey.SPACE:
				toAdd = ' ';

            default:
				if (e.ctrlKey && key == FlxKey.C)
					Clipboard.text = value;
				else if (e.ctrlKey && key == FlxKey.V)
					toAdd = Clipboard.text;
				else
					toAdd = CoolUtil.fromCharCode(e.charCode);
        }

		if (toAdd != null && printReg.match(toAdd))
		{
			if (filter != null)
				if (!filter.match(toAdd))
					return;

			value = value.substring(0, curSelected) + toAdd + value.substring(curSelected);

			if (typeCallback != null)
				typeCallback(toAdd);

			curSelected = curSelected + toAdd.length;
		}
    }

	function updateSearch()
	{
		if (toSearch == null)
			return;

		searchResult = '';

		if (toSearch != null && value.length > 0)
			for (sch in toSearch)
				if (sch.toLowerCase().startsWith(value.toLowerCase()))
				{
					searchResult = sch;

					break;
				}

		searchLabel.text = value.length <= 0 ? (searchDefault ?? '') : searchResult;
	}

	function updateCursorPos()
	{
		cursor.visible = isTyping;

		cursorTimer = 0;

		var bounds = label.textField.getCharBoundaries(curSelected - 1);

		cursor.x = this.x + labelX + (bounds == null ? 0 : bounds.x + bounds.width) - 1;

		var overflow:Float = Math.min(this.x + bg.width - labelX - cursor.width - cursor.x, 0);

		label.x = searchLabel.x = this.x + labelX + overflow;
		
		cursor.x += overflow;

		label.clipRect = FlxRect.get(-overflow, 0, bg.width - labelX * 2, label.frameHeight);
		searchLabel.clipRect = FlxRect.get(-overflow, 0, bg.width - labelX * 2, searchLabel.frameHeight);
	}
	
	function typedCharacterRegex(back:Bool, regs:Array<EReg>):Int
	{
		var total:Int = 1;

		var curReg:EReg = null;

		for (reg in regs)
		{
			if (reg.match(value.charAt(curSelected - (back ? 1 : 0))))
			{
				curReg = reg;

				break;
			}
		}

		while (curReg != null && curSelected + total * (back ? - 1 : 1) == FlxMath.bound(curSelected + total * (back ? - 1 : 1), 0, value.length) && curReg.match(value.charAt(curSelected + total * (back ? -1 : 1))))
			total++;

		return total;
	}
}