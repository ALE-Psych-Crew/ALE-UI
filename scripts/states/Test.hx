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

var multiTab:ALEMultiTab = new ALEMultiTab(50, 50 + ALEUIUtils.OBJECT_SIZE, 500, 500);
add(multiTab);
multiTab.draggable = true;

var button:ALEButton = new ALEButton(30, 30, 'Siempre');
multiTab.addObj('Group 2', button);
button.releaseCallback = () -> {
    game.camGame.shake(0.0025);
};

var circleButton:ALECircleButton = new ALECircleButton(30, 80, 'Creí', null, false);
multiTab.addObj('Group 2', circleButton);

var inputText:ALEInputText = new ALEInputText(30, 130);
multiTab.addObj('Group 2', inputText);
inputText.typeCallback = (a) -> {
    debugTrace(a);
}

var dropDownMenu:ALEDropDownMenu = new ALEDropDownMenu(30, 180, ['Que', 'Sería', 'Negro']);
multiTab.addObj('Group 2', dropDownMenu);
dropDownMenu.options = ['oso', 'donde', 'tu', 'ta', 'oso'];

var tab:ALETab = new ALETab(100, 100, null, 300);

var numericStepper:ALENumericStepper = new ALENumericStepper(30, 10);
tab.add(numericStepper);

var colorPicker:ALEColorPicker = new ALEColorPicker(30, 80, FlxColor.CYAN);
colorPicker.onChange = () -> {
    debugTrace('oso');
};
tab.add(colorPicker);

multiTab.addObj('Group 1', tab);

function onUpdate(elapsed:Float)
{
    if (Controls.RESET && !inputText.isTyping)
        resetCustomState();
}