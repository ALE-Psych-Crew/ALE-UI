package ale.ui;

import ale.ui.ALEMouseSpriteGroup;

import ale.ui.ALEUIUtils;

class ALEButton extends ALEMouseSpriteGroup
{
	public var bg:FlxSprite;
	public var label:FlxText;
	public var mask:FlxSprite;

	public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float, ?label:String)
	{
		super(x, y);

		var intW:Int = Math.floor(w ?? ALEUIUtils.BUTTON_WIDTH);
		var intH:Int = Math.floor(h ?? ALEUIUtils.BUTTON_HEIGHT);

		bg = new FlxSprite();
		bg.pixels = ALEUIUtils.uiBitmap(intW, intH);
		bg.updateHitbox();
		add(bg);

		label = new FlxText(0, 0, 0, label ?? 'Button', Math.floor(Math.min(intW, intH) / 1.5));
		add(label);
		label.font = ALEUIUtils.FONT;
		label.alignment = 'center';
		label.x = bg.x + bg.width / 2 - label.width / 2;
		label.y = bg.y + bg.height / 2 - label.height / 2;

		mask = new FlxSprite().makeGraphic(intW, intH, FlxColor.WHITE);
		add(mask);
		mask.alpha = 0;
	}

	override function overlapCallbackHandler(isOver:Bool)
	{
		mask.alpha = isOver || pressed ? 0.25 : 0;

		super.overlapCallbackHandler(isOver);
	}

	override function pressCallbackHandler(isPressed:Bool)
	{
		mask.color = isPressed ? FlxColor.BLACK : FlxColor.WHITE;

		mask.alpha = isPressed || overlaped ? 0.25 : 0;

		super.pressCallbackHandler(isPressed);
	}
}