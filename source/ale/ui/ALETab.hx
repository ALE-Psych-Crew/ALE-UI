package ale.ui;

import ale.ui.ALEUIUtils;
import ale.ui.ALEButton;
import ale.ui.ALEUISpriteGroup;

import flixel.math.FlxPoint;

class ALETab extends ALEUISpriteGroup
{
    public var border:ALEButton;

    public var bg:ALEUISprite;

    public var draggable(default, set):Bool;
    function set_draggable(val:Bool):Bool
    {
        draggable = val;

        if (!draggable)
            dragging = false;

        return draggable;
    }

    final positionSafety:Bool;

    var dragging(default, set):Bool;
    function set_dragging(val:Bool):Bool
    {
        dragging = val;

        if (dragging)
        {
            var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(cameras[0]);

            mouseOffset = FlxPoint.get(mousePos.x - this.x, mousePos.y - this.y);
        } else if (positionSafety) {
            x = FlxMath.bound(x, -width + ALEUIUtils.OBJECT_SIZE, FlxG.width - ALEUIUtils.OBJECT_SIZE);
            y = FlxMath.bound(y, ALEUIUtils.OBJECT_SIZE, FlxG.height);
        }

        return dragging;
    }

    var mouseOffset:FlxPoint;

    public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float, ?title:String, ?isDraggable:Bool, ?borderless:Bool, ?positionSafety:Bool)
    {
        super(x, y);

        w ??= (ALEUIUtils.OBJECT_SIZE * 10);
        h ??= (ALEUIUtils.OBJECT_SIZE * 10);

        bg = new ALEUISprite();
		bg.pixels = ALEUIUtils.uiBitmap(Math.floor(w), Math.floor(h), false, -75);
		bg.updateHitbox();
		add(bg);

        borderless ??= false;

        positionSafety ??= true;

        this.positionSafety = positionSafety && !borderless;
        
        if (!borderless)
        {
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
        }

        dragging = false;

        draggable = isDraggable ?? true && !borderless;
    }

    override function uiUpdate(elapsed:Float)
    {
        super.uiUpdate(elapsed);

        if (dragging)
        {
            var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(cameras[0]);

            x = mousePos.x - mouseOffset.x;
            y = mousePos.y - mouseOffset.y;
        }
    }
}