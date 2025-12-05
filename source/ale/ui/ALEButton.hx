package ale.ui;

import ale.ui.ALEMouseSpriteGroup;
import ale.ui.ALEUIUtils;

import flixel.text.FlxText;

import openfl.ui.Mouse;

class ALEButton extends ALEMouseSpriteGroup
{
	public var bg:ALEUISprite;
	public var label:FlxText;
	public var mask:ALEUISprite;

	public var changeCursorSkin:Bool = true;

	public function new(?x:Float, ?y:Float, ?lab:String, ?w:Float, ?h:Float, ?shadowed:Bool, ?allowMask:Bool)
	{
		super(x, y);

		var intW:Int = Math.floor(w ?? (ALEUIUtils.OBJECT_SIZE * 5));
		var intH:Int = Math.floor(h ?? ALEUIUtils.OBJECT_SIZE);

		bg = new ALEUISprite();
		bg.pixels = ALEUIUtils.uiBitmap(intW, intH, shadowed);
		bg.updateHitbox();
		add(bg);

		label = new FlxText(0, 0, 0, lab ?? 'Button', Math.floor(Math.min(intW, intH) / 1.5));
		add(label);
		label.font = ALEUIUtils.FONT;
		label.alignment = 'center';
		label.x = bg.x + bg.width / 2 - label.width / 2;
		label.y = bg.y + bg.height / 2 - label.height / 2;

		if (allowMask ?? true)
		{
			mask = new ALEUISprite();
			mask.makeGraphic(intW, intH, FlxColor.WHITE);
			add(mask);
			mask.alpha = 0;
		}
	}

	override function overlapCallbackHandler(isOver:Bool)
	{
		if (mask != null)
			mask.alpha = isOver || pressed ? 0.25 : 0;

		if (changeCursorSkin)
			Mouse.cursor = isOver ? 'button' : 'arrow';

		super.overlapCallbackHandler(isOver);
	}

	override function pressCallbackHandler(isPressed:Bool)
	{
		if (mask != null)
		{
			mask.color = isPressed ? FlxColor.BLACK : FlxColor.WHITE;
			mask.alpha = isPressed || overlaped ? 0.25 : 0;
		}

		super.pressCallbackHandler(isPressed);
	}
}