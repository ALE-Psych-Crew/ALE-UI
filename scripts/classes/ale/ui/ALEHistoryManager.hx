package ale.ui;

class ALEHistoryManager<T>
{
    public var undoStack:Array<T> = [];

    public var redoStack:Array<T> = [];

    public var maxLength(default, set):Int;
    function set_maxLength(val:Int):Int
    {
        if (maxLength == val)
            return val;

        maxLength = val;

        for (arr in [undoStack, redoStack])
            if (arr.length > maxLength)
            {
                var off:Int = arr.length - maxLength;

                arr.splice(0, off);
            }

        return maxLength;
    }

    public function new(?max:Int, ?initial:Null<T>)
    {
        maxLength = max ?? 50;

        if (initial != null)
            push(initial);
    }

    public function push(val:T)
    {
        limitedPush(undoStack, val);

        redoStack = [];
    }

    public function undo():Null<T>
    {
        if (undoStack.length <= 0)
            return null;

        limitedPush(redoStack, undoStack.pop());

        return undoStack[undoStack.length - 1];
    }

    public function redo():Null<T>
    {
        if (redoStack.length <= 0)
            return null;

        var val:T = redoStack.pop();

        limitedPush(undoStack, val);

        return val;
    }

    public function clear()
    {
        undoStack.resize(0);
        redoStack.resize(0);
    }

    public function destroy()
    {
        clear();

        undoStack = null;
        redoStack = null;
    }

    function limitedPush(arr:Array<T>, val:T)
    {
        if (arr.length > 0 && val == arr[arr.length - 1])
            return;

        arr.push(val);

        if (arr.length > maxLength)
            var newVal:T = arr.shift();
    }
}