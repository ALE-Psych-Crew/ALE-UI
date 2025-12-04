package ale.ui;

import scripting.haxe.ScriptSprite as FlxSprite;

class ALEUISprite extends FlxSprite
{
    public var allowUpdate:Bool = true;

    override function update(elapsed:Float)
    {
        if (!allowUpdate)
            return;

        uiUpdate(elapsed);

        super.update(elapsed);
    }

    function uiUpdate(elapsed:Float) {}

    public var allowDraw:Bool = true;

    override function draw()
    {
        if (!allowDraw)
            return;

        uiDraw();

        super.draw();
    }

    function uiDraw() {}
}