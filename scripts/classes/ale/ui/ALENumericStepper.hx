package ale.ui;

import ale.ui.ALEUIUtils;
import ale.ui.ALEInputText;
import ale.ui.ALEButton;
import ale.ui.ALEUISpriteGroup;

class ALENumericStepper extends ALEUISpriteGroup
{
    public var onChange:Void -> Void;

	public var bg:ALEInputText;

    public var plusButton:ALEButton;
    public var minusButton:ALEButton;

    public var value(default, set):Float;
    function set_value(val:Float):Float
    {
        value = val;

        if (value < min)
            value = min;

        if (value > max)
            value = max;

        bg.value = Std.string(value);
        bg.curSelected = bg.value.length;

        return value;
    }

    public var max(default, set):Float;
    function set_max(val:Float):Float
    {
        max = val;

        value = value;

        return max;
    }

    public var min(default, set):Float;
    function set_min(val:Float):Float
    {
        min = val;

        value = value;

        return min;
    }

    public function new(?x:Float, ?y:Float, ?min:Float, ?max:Float, ?initial:Float, ?change:Float, ?w:Float, ?h:Float)
    {
        super(x, y);

        var theWidth:Float = w ?? ALEUIUtils.OBJECT_SIZE * 3;

        bg = new ALEInputText(0, 0, [], theWidth, h);
        add(bg);
        bg.filter = ~/^[-+]?(\d+)?(\.\d+)?$/;
        bg.focusCallback = (isTyping) -> {
            if (!isTyping)
            {
                var changeVal:Float = Std.parseFloat(bg.value);

                if (!Math.isNaN(changeVal))
                    value = changeVal;
                
                if (onChange != null)
                    onChange();
            }
        };

        change ??= 1;

        plusButton = new ALEButton(theWidth, 0, '+', ALEUIUtils.OBJECT_SIZE, h);
        add(plusButton);
        plusButton.releaseCallback = () -> {
            value = value + change;

            if (onChange != null)
                onChange();
        };
        plusButton.changeCursorSkin = false;

        minusButton = new ALEButton(theWidth + ALEUIUtils.OBJECT_SIZE, 0, '-', ALEUIUtils.OBJECT_SIZE, h);
        add(minusButton);
        minusButton.releaseCallback = () -> {
            value = value - change;

            if (onChange != null)
                onChange();
        };
        minusButton.changeCursorSkin = false;

        value = initial ?? 0;

        this.max = max ?? 100;

        this.min = min ?? 0;
    }
}