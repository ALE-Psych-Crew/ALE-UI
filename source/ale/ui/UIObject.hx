package ale.ui;

interface UIObject
{
    public var allowUpdate:Bool;

    public function uiUpdate(elapsed:Float):Void;

    public var allowDraw:Bool;

    public function uiDraw():Void;
}