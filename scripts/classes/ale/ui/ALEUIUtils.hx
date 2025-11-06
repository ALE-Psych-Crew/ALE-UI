package ale.ui;

import openfl.display.BitmapData;
import openfl.geom.Rectangle;

import flixel.util.FlxColor;

class ALEUIUtils
{   
    public static final BUTTON_WIDTH:Int = 150;
    public static final BUTTON_HEIGHT:Int = 30;

    public static var FONT:String = Paths.font('vcr.ttf');

    public static var COLOR:FlxColor = FlxColor.fromRGB(50, 70, 100);
    public static var OUTLINE_COLOR:FlxColor = FlxColor.WHITE;

    public static function adjustColorBrightness(color:FlxColor, factor:Float):FlxColor
    {
        var f = factor / 100;

        inline function adjust(c:Int):Int
            return f > 0 ? Std.int(c + (255 - c) * f) : Std.int(c * (1 + f));

        return FlxColor.fromRGB(adjust(color >> 16 & 0xFF), adjust(color >> 8 & 0xFF), adjust(color & 0xFF));
    }
    
    public static function uiBitmap(width:Int, height:Int, ?shadowed:Bool, ?brightness:Float):BitmapData
    {
        var bitmap:BitmapData = new BitmapData(width, height, true, FlxColor.TRANSPARENT);

        var midHeight:Int = Math.floor(height / 2);

        var rect:Rectangle = new Rectangle();

        rect.setTo(0, 0, width, midHeight);
        bitmap.fillRect(rect, adjustColorBrightness(COLOR, brightness));

        rect.setTo(0, midHeight, width, midHeight);
        bitmap.fillRect(rect, adjustColorBrightness(COLOR, (shadowed ?? true ? -30 : 0) + brightness));

        outlineBitmap(bitmap);

        return bitmap;
    }
    
    public static function outlineBitmap(bitmap:BitmapData, ?size:Int)
    {
        var outlineSize:Int = size ?? 1;

        var rect:Rectangle = new Rectangle();

        rect.setTo(0, 0, outlineSize, bitmap.height);
        bitmap.fillRect(rect, OUTLINE_COLOR);

        rect.setTo(bitmap.width - outlineSize, 0, outlineSize, bitmap.height);
        bitmap.fillRect(rect, OUTLINE_COLOR);

        rect.setTo(0, 0, bitmap.width, outlineSize);
        bitmap.fillRect(rect, OUTLINE_COLOR);

        rect.setTo(0, bitmap.height - outlineSize, bitmap.width, outlineSize);
        bitmap.fillRect(rect, OUTLINE_COLOR);

        return bitmap;
    }
}