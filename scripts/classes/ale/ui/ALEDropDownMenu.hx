package ale.ui;

import ale.ui.ALEButton;

import scripting.haxe.ScriptSpriteGroup;

import ale.ui.ALEUIUtils;

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

	public function new(?x:Float, ?y:Float, ?opts:Array<String>, ?w:Float, ?h:Float)
	{
		super(x, y);

		theWidth = w ?? ALEUIUtils.OBJECT_SIZE * 5;
		theHeight = h ?? ALEUIUtils.OBJECT_SIZE;

		bg = new FlxSprite();
		bg.pixels = ALEUIUtils.uiBitmap(theWidth, theHeight, false, -25);
		add(bg);

		openButton = new ALEButton(theWidth, 0, '+', theHeight, theHeight);
		add(openButton);
		openButton.releaseCallback = () -> {
			open = !open;
		};

		buttons = new FlxSpriteGroup<ALEButton>();
		add(buttons);
		buttons.y = this.y + theHeight;

		for (index => opt in opts)
		{
			var but:ALEButton = new ALEButton(0, 0, opt, theWidth, theHeight);
			but.y = theHeight * index;
			but.changeCursorSkin = false;
			but.releaseCallback = () -> {
				value = opt;

				open = false;
			};

			buttons.add(but);
		}

		open = false;
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
}