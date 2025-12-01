package ale.ui;

import ale.ui.ALEUIUtils;

import ale.ui.ALEButton;

import scripting.haxe.ScriptSpriteGroup;

import flixel.math.FlxRect;

//import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedSpriteGroup as FlxSpriteGroup;

class ALETab extends ScriptSpriteGroup
{
    public var border:ALEButton;

    public var minimizeButton:ALEButton;

    public var bg:FlxSprite;

    public var content:FlxSpriteGroup;

    public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float, ?title:String)
    {
        super(x, y);

        w ??= (ALEUIUtils.OBJECT_SIZE * 10);
        h ??= (ALEUIUtils.OBJECT_SIZE * 10);

        border = new ALEButton(0, 0, title ?? 'Title', w - ALEUIUtils.OBJECT_SIZE, null, null, false);
        border.label.alignment = 'left';
        border.label.x = 10;
        border.changeCursorSkin = false;
        add(border);
        border.y = this.y - border.bg.height;

        minimizeButton = new ALEButton(w - ALEUIUtils.OBJECT_SIZE, 0, '-', ALEUIUtils.OBJECT_SIZE);
        add(minimizeButton);
        minimizeButton.y = this.y - minimizeButton.bg.height;

        bg = new FlxSprite();
		bg.pixels = ALEUIUtils.uiBitmap(Math.floor(w), Math.floor(h), false, -75);
		bg.updateHitbox();
		add(bg);

        content = new FlxSpriteGroup();
        add(content);
    }

    public function addObj(obj:FlxSprite):FlxSprite
    {
        return content.add(obj);
    }

    public function addObj(obj:FlxSprite, ?destroy:Bool)
    {
        content.remove(obj, destroy);
    }
}