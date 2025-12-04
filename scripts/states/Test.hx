import ale.ui.ALEButton;
import ale.ui.ALECircleButton;
import ale.ui.ALEUIUtils;
import ale.ui.ALEInputText;
import ale.ui.ALEDropDownMenu;
import ale.ui.ALENumericStepper;
import ale.ui.ALETab;
import ale.ui.ALEMultiTab;
import ale.ui.ALEColorPicker;

import lime.app.Application;

WindowsAPI.setWindowBorderColor(33, 33, 33);

if (true)
{
    Application.current.window.width = (1920 / 2) * 0.9;
    Application.current.window.height = (1080 / 2) * 0.9;
    Application.current.window.x = 1920 / 4 - Application.current.window.width / 2 + 20;
    Application.current.window.y = 1080 / 4 - Application.current.window.height / 2 + 50;
}

var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/menuBG'));
add(bg);
bg.alpha = 0.125;

var tab:ALEMultiTab = new ALEMultiTab(50, 50 + ALEUIUtils.OBJECT_SIZE, 500, 500);
add(tab);
tab.draggable = true;

var button:ALEButton = new ALEButton(30, 30, 'Siempre');
tab.addObj('Group 2', button);
button.releaseCallback = () -> {
    game.camGame.shake(0.0025);
};

var circleButton:ALECircleButton = new ALECircleButton(30, 80, 'Creí', null, false);
tab.addObj('Group 1', circleButton);

var inputText:ALEInputText = new ALEInputText(30, 130);
tab.addObj('Group 2', inputText);
inputText.typeCallback = (a) -> {
    debugTrace(a);
}

var dropDownMenu:ALEDropDownMenu = new ALEDropDownMenu(30, 180, ['Que', 'Sería', 'Negro']);
tab.addObj('Group 2', dropDownMenu);
dropDownMenu.options = ['oso', 'donde', 'tu', 'ta', 'oso'];

var numericStepper:ALENumericStepper = new ALENumericStepper(30, 230);
tab.addObj('Group 2', numericStepper);

var colorPicker:ALEColorPicker = new ALEColorPicker(30, 200, FlxColor.CYAN);
tab.addObj('Group 1', colorPicker);
colorPicker.onChange = () -> {
    debugTrace('oso');
};

function onUpdate(elapsed:Float)
{
    if (Controls.RESET && !inputText.isTyping)
        resetCustomState();
}