package ale.ui;

import scripting.haxe.ScriptSpriteGroup as FlxSpriteGroup;

class ALEUISpriteGroup extends FlxSpriteGroup
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