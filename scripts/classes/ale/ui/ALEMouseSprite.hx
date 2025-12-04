package ale.ui;

import ale.ui.ALEUISprite;

class ALEMouseSprite extends ALEUISprite
{
	public var overlaped:Bool = false;

	public var onOverlapChange:Bool -> Void;

	public var pressed:Bool = false;

	public var onPressChange:Bool -> Void;

	public var pressCallback:Void -> Void;
	public var releaseCallback:Void -> Void;

	override function uiUpdate(elapsed:Float)
	{
		super.uiUpdate(elapsed);

		var newOverlaped:Bool = FlxG.mouse.overlaps(super, cameras[0]);

		if (newOverlaped != overlaped)
            overlapCallbackHandler(newOverlaped);

		overlaped = newOverlaped;

		var newPressed:Bool = (newOverlaped && FlxG.mouse.justPressed) || (pressed && !FlxG.mouse.justReleased);

		if (newPressed != pressed)
            pressCallbackHandler(newPressed);

		pressed = newPressed;
	}

    public function overlapCallbackHandler(isOver:Bool)
    {
        if (onOverlapChange != null)
            onOverlapChange(isOver);
    }

    public function pressCallbackHandler(isPressed:Bool)
    {
        if (onPressChange != null)
            onPressChange(isPressed); 

		if (isPressed && pressCallback != null)
			pressCallback();

		if (!isPressed && releaseCallback != null)
			releaseCallback();
    }
}