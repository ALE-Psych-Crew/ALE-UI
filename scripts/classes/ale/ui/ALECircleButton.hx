package ale.ui;

import ale.ui.ALEMouseSpriteGroup;
import ale.ui.ALEUIUtils;

import flixel.addons.display.shapes.FlxShapeCircle;

import openfl.ui.Mouse;

class ALECircleButton extends ALEMouseSpriteGroup
{
	public var bg:FlxSprite;
	public var fill:FlxSprite;
	public var label:FlxText;
	public var mask:FlxSprite;

	public var changeCursorSkin:Bool = true;

	public var value(default, set):Bool;
	function set_value(val:Bool):Bool
	{
		value = val;

		fill.visible = val;

		return value;
	}

	public function new(?x:Float, ?y:Float, ?label:String, ?size:Float, ?defValue:Bool)
	{
		super(x, y);

		size ??= ALEUIUtils.OBJECT_SIZE;

		var intSize:Int = Math.floor(size / 2);

		bg = new FlxShapeCircle(0, 0, intSize, {thickness: 2, color: ALEUIUtils.OUTLINE_COLOR}, ALEUIUtils.COLOR);
		add(bg);

		var fillSize:Int = Math.floor(intSize * 0.55);

		fill = new FlxShapeCircle(bg.width / 2 - fillSize, bg.height / 2 - fillSize, Math.floor(fillSize), {color: 0x0}, ALEUIUtils.OUTLINE_COLOR);
		add(fill);

		mask = new FlxShapeCircle(0, 0, intSize, {thickness: 2, color: FlxColor.WHITE}, FlxColor.WHITE);
		add(mask);
		mask.alpha = 0;

		label = new FlxText(intSize * 2.4, 0, 0, label ?? 'Button', Math.floor(intSize * 1.5));
		add(label);
		label.y = this.y + intSize - label.height / 2;
		label.font = ALEUIUtils.FONT;

		value = defValue ?? false;
	}

	override function overlapCallbackHandler(isOver:Bool)
	{
		mask.alpha = isOver || pressed ? 0.25 : 0;

		if (changeCursorSkin)
			Mouse.cursor = isOver ? 'button' : 'arrow';

		super.overlapCallbackHandler(isOver);
	}

	override function pressCallbackHandler(isPressed:Bool)
	{
		mask.color = isPressed ? FlxColor.BLACK : FlxColor.WHITE;

		mask.alpha = isPressed || overlaped ? 0.25 : 0;

		if (!isPressed)
			value = !value;

		super.pressCallbackHandler(isPressed);
	}
}