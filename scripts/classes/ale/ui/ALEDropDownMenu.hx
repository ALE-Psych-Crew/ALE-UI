package ale.ui;

import ale.ui.ALEUIUtils;

import ale.ui.ALEButton;
import ale.ui.ALEInputText;

import scripting.haxe.ScriptSpriteGroup;

//import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedSpriteGroup as FlxSpriteGroup;

import flixel.math.FlxRect;

class ALEDropDownMenu extends ScriptSpriteGroup
{
	public var bg:ALEButton;

	public var openButton:ALEButton;

	public var buttons:FlxSpriteGroup<ALEButton>;

	public var value(default, set):String;
	function set_value(val:String):String
	{
		value = val;

		return value;
	}

	var theWidth:Float;
	public var theHeight:Float;

	var buttonsY:Float = 0;

	public var open(default, set):Bool;
	function set_open(val:Bool):Bool
	{
		open = val;

		buttons.visible = buttons.active = open;

		openButton.label.text = open ? '-' : '+';

		buttonsY = 0;

		return open;
	}

	public var options(default, set):Array<String>;
	function set_options(val:Array<String>):Array<String>
	{
		options = val;

		if (bg != null)
		{
			bg.value = getFirstOption();
			bg.toSearch = options;
		}

		buttons.clear();

		for (opt in options)
			addOption(opt);

		return options;
	}

	public function new(?x:Float, ?y:Float, ?opts:Array<String>, ?w:Float, ?h:Float)
	{
		super(x, y);

		theWidth = w ?? ALEUIUtils.OBJECT_SIZE * 5;
		theHeight = h ?? ALEUIUtils.OBJECT_SIZE;

		openButton = new ALEButton(theWidth, 0, '+', theHeight, theHeight);
		openButton.changeCursorSkin = false;
		openButton.releaseCallback = () -> {
			open = !open;
		};

		buttons = new FlxSpriteGroup<ALEButton>();
		buttons.y = theHeight;

		options = opts;

		open = false;

		bg = new ALEInputText(0, 0, opts, theWidth, theHeight);
		bg.value = getFirstOption();
		bg.curSelected = bg.value.length;
		bg.focusCallback = (isFocused) -> {
			if (!isFocused && !opts.contains(bg.value))
			{
				if (bg.searchResult != null && bg.searchResult.length > 0)
					bg.value = bg.searchResult;
				else
					bg.value = getFirstOption();

				bg.curSelected = bg.value.length;
			}
		};
		
		add(bg);
		add(openButton);
		add(buttons);
	}

	override function update(elapsed:Float)
	{
		if (open)
		{
			if (FlxG.mouse.wheel != 0)
				buttonsY += FlxG.mouse.wheel * 15;

			buttonsY = FlxMath.bound(buttonsY, -theHeight * (buttons.members.length - 1), 0);

			buttons.y = ALEUIUtils.fpsLerp(buttons.y, this.y + buttonsY + theHeight, 0.3);

			buttons.clipRect = new FlxRect(0, this.y - buttons.y + theHeight, buttons.width, this.y + buttons.height);
		}

		for (but in buttons)
		{
			but.active = but.y - buttons.y + buttonsY > -theHeight;
		}

		super.update(elapsed);
	}

	public function addOption(option:String)
	{
		var but:ALEButton = new ALEButton(0, 0, option, theWidth, theHeight);
		but.y = theHeight * buttons.members.length;
		but.changeCursorSkin = false;
		but.releaseCallback = () -> {
			value = option;

			bg.value = value;
			bg.curSelected = bg.value.length;

			open = false;
		};

		buttons.add(but);
	}

	public function removeOption(option:String)
	{
		if (!options.contains(option))
			return;

		options.remove(option);

		bg.toSearch.remove(option);

		var yIndex:Int = 0;

		for (but in buttons)
		{
			if (but.label.text == option)
			{
				buttons.remove(but, true);

				shouldOrder = true;

				continue;
			}

			but.y = buttons.y + yIndex * theHeight;

			yIndex++;
		}
	}

	function getFirstOption():String
	{
		return options[0];
	}
}