package ale.ui;

import ale.ui.ALEUIUtils;

import ale.ui.ALEButton;

import scripting.haxe.ScriptSpriteGroup;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;

//import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedSpriteGroup as FlxSpriteGroup;

class ALETab extends ScriptSpriteGroup
{
    public var border:ALEButton;

    public var bg:FlxSprite;

    public var draggable(default, set):Bool;
    function set_draggable(val:Bool):Bool
    {
        draggable = val;

        if (!draggable)
            dragging = false;

        return draggable;
    }

    var dragging(default, set):Bool;
    function set_dragging(val:Bool):Bool
    {
        dragging = val;

        if (dragging)
        {
            var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(cameras[0]);

            mouseOffset = FlxPoint.get(mousePos.x - this.x, mousePos.y - this.y);
        } else {
            x = FlxMath.bound(x, -width + ALEUIUtils.OBJECT_SIZE, FlxG.width - ALEUIUtils.OBJECT_SIZE);
            y = FlxMath.bound(y, ALEUIUtils.OBJECT_SIZE, FlxG.height);
        }

        return dragging;
    }

    var mouseOffset:FlxPoint;

    public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float, ?title:String, ?isDraggable:Bool)
    {
        super(x, y);

        w ??= (ALEUIUtils.OBJECT_SIZE * 10);
        h ??= (ALEUIUtils.OBJECT_SIZE * 10);

        border = new ALEButton(0, 0, title ?? 'Title', w, null, null, false);
        border.label.alignment = 'left';
        border.label.x = 10;
        border.changeCursorSkin = false;
        add(border);
        border.y = this.y - border.bg.height;
        border.pressCallback = () -> {
            if (draggable)
                dragging = true;
        };
        border.releaseCallback = () -> {
            if (draggable)
                dragging = false;
        };

        bg = new FlxSprite();
		bg.pixels = ALEUIUtils.uiBitmap(Math.floor(w), Math.floor(h), false, -75);
		bg.updateHitbox();
		add(bg);

        dragging = false;

        draggable = isDraggable ?? true;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (dragging)
        {
            var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(cameras[0]);

            x = mousePos.x - mouseOffset.x;
            y = mousePos.y - mouseOffset.y;
        }
    }

    override public function remove(obj:FlxSprite, ?destroy:Bool)
    {
        if ([border, bg].contains(obj))
            return;

        remove(obj, destroy);
    }
}