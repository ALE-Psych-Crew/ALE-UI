package ale.ui;

import flixel.text.FlxText;

class Slider extends UISpriteGroup
{
    public var button:Button;
    public var bar:UISprite;
    public var label:FlxText;

    public var onChange:Float -> Void;

    public var value(default, set):Float = 0;

    public var min(default, set):Float = 0;

    public var max(default, set):Float = 100;

    public var float:Bool = false;

    public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float, ?initial:Float, ?min:Float, ?max:Float, ?float:Bool)
    {
        super(x, y);

        bar = new UISprite();
        bar.pixels = UIUtils.uiBitmap(Std.int(w ?? (UIUtils.OBJECT_SIZE * 8)), Std.int(h ?? (UIUtils.OBJECT_SIZE * 0.35)), false, -75);
        add(bar);

        button = new Button(0, 0, '', bar.width / 16, bar.height * 3.125);
        button.changeCursorSkin = false;
        add(button);
        button.y = this.y + bar.height / 2 - button.height / 2;

        this.float = float ?? false;

        this.min = min ?? 0;
        this.max = max ?? 100;

        value = initial ?? 0;

        label = new FlxText(bar.width + bar.width * 0.075, 0, 0, '$value', Math.floor(bar.height * 2.5));
        label.font = UIUtils.FONT;
        label.y = bar.height / 2 - label.height / 2;
        add(label);
    }

    override function uiUpdate(elapsed:Float)
    {
        super.uiUpdate(elapsed);

        if (button.pressed)
            value = min + FlxMath.bound((FlxG.mouse.getViewPosition(camera).x - this.x) / bar.width, 0, 1) * (max - min);
    }
    
    function set_value(val:Float):Float
    {
        if (value == val)
            return value;

        value = FlxMath.bound(val, min, max);

        if (!float)
            value = Math.floor(value);

        if (label != null)
            label.text = Std.string(FlxMath.roundDecimal(value, 3));

        button.x = this.x + ((value - min) / (max - min)) * bar.width - button.width / 2;

        if (onChange != null)
            onChange(value);

        return value;
    }

    function set_min(val:Float):Float
    {
        if (min >= max)
            return min;

        min = Math.abs(val);

        value = value;

        return min;
    }

    function set_max(val:Float):Float
    {
        if (max <= min)
            return max;

        max = Math.abs(val);

        value = value;

        return max;
    }

    function set_float(val:Bool):Bool
    {
        float = val;

        value = value;

        return float;
    }
}