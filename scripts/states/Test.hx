import ale.ui.ALEButton;
import ale.ui.ALEButton;
import ale.ui.ALEUIUtils;

import lime.app.Application;

WindowsAPI.setWindowBorderColor(33, 33, 33);

if (false)
{
    Application.current.window.width = (1920 / 2) * 0.9;
    Application.current.window.height = (1080 / 2) * 0.9;
    Application.current.window.x = 1920 / 4 - Application.current.window.width / 2 + 20;
    Application.current.window.y = 1080 / 4 - Application.current.window.height / 2 + 50;
}

var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/menuBG'));
add(bg);
bg.alpha = 0.125;

var button:ALEButton = new ALEButton(100, 100);
add(button);
button.releaseCallback = () -> {
    trace('ALEButton');
};