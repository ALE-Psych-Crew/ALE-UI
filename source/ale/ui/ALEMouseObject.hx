package ale.ui;

interface ALEMouseObject
{
    public var overlaped:Bool;

    public var onOverlapChange:Bool -> Void;

    public var pressed:Bool;

    public var onPressChange:Bool -> Void;

    public var pressCallback:Void -> Void;
    public var releaseCallback:Void -> Void;

    public function overlapCallbackHandler(isOver:Bool):Void;

    public function pressCallbackHandler(isPressed:Bool):Void;
}