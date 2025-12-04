package ale.ui;

import ale.ui.ALEUISpriteGroup;
import ale.ui.ALEUIUtils;
import ale.ui.ALEButton;
import ale.ui.ALETab;

class ALEMultiTab extends ALETab
{
    public var groups:StringMap<ALEUISpriteGroup> = new StringMap<ALEUISpriteGroup>();

    public var curGroup(default, set):String;
    function set_curGroup(val:String):String
    {
        if (curGroup == val)
            return curGroup;

        curGroup = val;

        for (group in groups.keys())
        {
            var grp:ALEUISpriteGroup = groups.get(group);

            grp.allowUpdate = grp.allowDraw = group == curGroup;
        }

        return curGroup;
    }
    
    public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float, ?groups:Array<String>, ?isDraggable:Bool)
    {
        super(x, y, w, h, '', isDraggable);

        var cleanGroups:Array<String> = [];

        for (group in groups ??= ['Group 1', 'Group 2'])
            if (!cleanGroups.contains(group))
                cleanGroups.push(group);

        for (index => group in cleanGroups)
        {
            var wid:Float = w / cleanGroups.length;

            var button:ALEButton = new ALEButton(wid * index, -ALEUIUtils.OBJECT_SIZE, group, wid);
            add(button);
            button.changeCursorSkin = false;
            button.releaseCallback = () -> {
                curGroup = group;
            };

            this.groups.set(group, new ALEUISpriteGroup());
        }
        
        for (group in this.groups)
            add(group);

        curGroup = cleanGroups[0];
    }

    public function addObj(group:String, obj:FlxSprite):FlxSprite
    {
        if (!groups.exists(group))
            return obj;

        groups.get(group).add(obj);

        return obj;
    }

    public function removeObj(group:String, obj:FlxSprite, ?destroy:Bool):FlxSprite
    {
        if (!groups.exists(group))
            return obj;

        groups.get(group).remove(obj, destroy);

        return obj;
    }

    public function insertObj(group:String, index:Int, obj:FlxSprite):FlxSprite
    {
        if (!groups.exists(group))
            return obj;

        groups.get(group).insert(index, obj);

        return obj;
    }
}