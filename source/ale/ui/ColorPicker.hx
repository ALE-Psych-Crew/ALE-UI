package ale.ui;

import ale.ui.MouseSprite;
import ale.ui.UISpriteGroup;
import ale.ui.UISprite;
import ale.ui.UIUtils;

import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;

import ale.ui.UpdateColorType;

class ColorPicker extends UISpriteGroup
{
    var shaderHSB:String = '
        #pragma header

        vec3 hsv2rgb(vec3 c)
        {
            vec4 k = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
            
            vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
            
            return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
        }

        uniform float hue;

        void main()
        {
            vec2 uv = openfl_TextureCoordv.xy;
            
            vec4 tex = texture2D(bitmap, uv);

            if(tex.a > 0.0)
                tex.rgb += hsv2rgb(vec3(hue / 360, uv.x, 1.0 - uv.y));

            gl_FragColor = tex;
        }
    ';

	var selectingHSB:Bool = false;
	public var spriteHSB:MouseSprite;
	public var selHSB:UISprite;

    public var shaderHUE:String = '
        #pragma header

        vec3 hsv2rgb(vec3 c)
        {
            vec4 k = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
            
            vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
            
            return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
        }

        void main()
        {
            vec2 uv = openfl_TextureCoordv.xy;
            
            vec4 tex = texture2D(bitmap, uv);

            if(tex.a > 0.0)
                tex.rgb += hsv2rgb(vec3(uv.x, 1, 1));

            gl_FragColor = tex;
        }
    ';

	var selectingHUE:Bool = false;
	public var spriteHUE:MouseSprite;
	public var selHUE:UISprite;

	public function new(?x:Float, ?y:Float, ?color:Null<FlxColor>, ?w:Float, ?h:Float)
	{
		super(x, y);

		var intW:Int = Math.floor(w ?? UIUtils.OBJECT_SIZE * 6);
		var intH:Int = Math.floor(h ?? UIUtils.OBJECT_SIZE * 6);

		spriteHSB = new MouseSprite();
		spriteHSB.makeGraphic(intW, intH, FlxColor.BLACK);
		add(spriteHSB);
		UIUtils.outlineBitmap(spriteHSB.pixels);
		spriteHSB.shader = new RuntimeShader('shaderHSB', shaderHSB);
		spriteHSB.pressCallback = () -> {
			selectingHSB = true;
		};
		spriteHSB.releaseCallback = () -> {
			selectingHSB = false;
		};

		var radius:Int = Math.floor(Math.max(intW, intH) / 15);

		selHSB = new UISprite();
		selHSB.makeGraphic(radius, radius, FlxColor.BLACK);
		UIUtils.outlineBitmap(selHSB.pixels);
		add(selHSB);
		selHSB.offset.x = selHSB.offset.y = radius / 2;
		selHSB.angle = 45;

		spriteHUE = new MouseSprite(0, intH * 1.1);
		spriteHUE.makeGraphic(intW, Math.floor(intH / 7.5), FlxColor.BLACK);
		UIUtils.outlineBitmap(spriteHUE.pixels);
		add(spriteHUE);
		spriteHUE.shader = new RuntimeShader('shaderHUE', shaderHUE);
		spriteHUE.pressCallback = () -> {
			selectingHUE = true;
		};
		spriteHUE.releaseCallback = () -> {
			selectingHUE = false;
		};

		selHUE = new UISprite();
		selHUE.makeGraphic(Math.floor(radius * 0.6), Math.floor(intH / 6), FlxColor.BLACK);
		UIUtils.outlineBitmap(selHUE.pixels);
		add(selHUE);
		selHUE.y = spriteHUE.y + spriteHUE.height / 2 - selHUE.height / 2;
		selHUE.offset.x = selHUE.width / 2;

		setColor(color ?? FlxColor.WHITE);
	}

	public var brightness:Float = 1;
	public var saturation:Float = 1;
	public var hue:Float = 0;

	public var curColor(get, never):Null<FlxColor>;

	function get_curColor():Null<FlxColor>
		return FlxColor.fromHSB(hue, saturation, brightness);

	var lastCol:Null<FlxColor>;

	function setColor(value:Null<FlxColor>):Null<FlxColor>
	{
		var hsb = rgbToHSB(value >> 16 & 0xFF, value >> 8 & 0xFF, value & 0xFF);

		hue = hsb.h;
		brightness = hsb.b;
		saturation = hsb.s;

		selHUE.x = spriteHUE.x + hue / 360 * spriteHUE.width;

		selHSB.x = spriteHSB.x + saturation * spriteHSB.width;
		selHSB.y = spriteHSB.y + spriteHSB.height - (brightness * spriteHSB.height);

		updateColor(UpdateColorType.HSB);
		updateColor(UpdateColorType.HUE);

		lastCol = curColor;

		return curColor;
	}

	public var onChange:Void -> Void;

	override function uiUpdate(elapsed:Float)
	{
		super.uiUpdate(elapsed);

		if (selectingHSB || selectingHUE)
		{
			var mousePos:FlxPoint = FlxG.mouse.getViewPosition(cameras[0]);

			if (selectingHSB)
			{
				selHSB.x = FlxMath.bound(mousePos.x, spriteHSB.x, spriteHSB.x + spriteHSB.width);
				selHSB.y = FlxMath.bound(mousePos.y, spriteHSB.y, spriteHSB.y + spriteHSB.height);

				updateColor(UpdateColorType.HSB);
			}

			if (selectingHUE)
			{
				selHUE.x = FlxMath.bound(mousePos.x, spriteHUE.x, spriteHUE.x + spriteHUE.width);

				updateColor(UpdateColorType.HUE);
			}

			if (lastCol != curColor)
			{
				if (onChange != null)
					onChange();

				lastCol = curColor;
			}
		}
	}

	var lastColor:Null<FlxColor> = null;

	function updateColor(type:UpdateColorType)
	{
		switch (type)
		{
			case UpdateColorType.HSB:
				saturation = (selHSB.x - spriteHSB.x) / spriteHSB.width;
				brightness = 1 - (selHSB.y - spriteHSB.y) / spriteHSB.height;
			case UpdateColorType.HUE:
				hue = (selHUE.x - spriteHUE.x) / spriteHUE.width * 360;
					
				cast(spriteHSB.shader, RuntimeShader).setFloat('hue', hue);
							
				setColorOffset(selHUE, FlxColor.fromHSB(hue, 1, 1));
		}

		if (lastColor != curColor)
		{
			setColorOffset(selHSB, curColor);

			lastColor = curColor;
		}
	}

    function setColorOffset(spr:UISprite, color:Null<FlxColor>)
    {
        spr.colorTransform.redOffset = color >> 16 & 0xFF;
        spr.colorTransform.greenOffset = color >> 8 & 0xFF;
        spr.colorTransform.blueOffset = color & 0xFF;
    }

    function rgbToHSB(r:Int, g:Int, b:Int):{h:Float, s:Float, b:Float}
    {
        var rf:Float = r / 255;
        var gf:Float = g / 255;
        var bf:Float = b / 255;

        var max:Float = Math.max(rf, Math.max(gf, bf));

        var delta:Float = max - Math.min(rf, Math.min(gf, bf));

        var h:Float = 0;
        var s:Float = max == 0 ? 0 : delta / max;
        var b:Float = max;

        if (delta != 0)
        {
            if (max == rf)
                h = (gf - bf) / delta % 6;
            else if (max == gf)
                h = (bf - rf) / delta + 2;
            else
                h = (rf - gf) / delta + 4;

            h *= 60;

            if (h < 0)
                h += 360;
        }

        return {
            h: h,
            s: s,
            b: b
        };
    }
}