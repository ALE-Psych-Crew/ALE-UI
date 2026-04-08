package ale.ui;

import ale.ui.UIUtils;
import ale.ui.Button;
import ale.ui.UISpriteGroup;

import flixel.math.FlxPoint;

class Tab extends UISpriteGroup
{
    public var border:Button;

    public var bg:UISprite;

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
            x = FlxMath.bound(x, -width + UIUtils.OBJECT_SIZE, FlxG.width - UIUtils.OBJECT_SIZE);
            y = FlxMath.bound(y, UIUtils.OBJECT_SIZE, FlxG.height);
        }

        return dragging;
    }

    var mouseOffset:FlxPoint;

    public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float, ?title:String, ?isDraggable:Bool, ?borderless:Bool, ?positionSafety:Bool)
    {
        super(x, y);

        w ??= (UIUtils.OBJECT_SIZE * 10);
        h ??= (UIUtils.OBJECT_SIZE * 10);

        bg = new UISprite();
		bg.pixels = UIUtils.uiBitmap(Math.floor(w), Math.floor(h), false, -75);
		bg.updateHitbox();
		add(bg);

        borderless ??= false;

        positionSafety ??= true;

        this.positionSafety = positionSafety && !borderless;
        
        if (!borderless)
        {
            border = new Button(0, 0, title ?? 'Title', w, null, null, false);
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