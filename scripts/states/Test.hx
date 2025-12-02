import ale.ui.ALEButton;
import ale.ui.ALECircleButton;
import ale.ui.ALEUIUtils;
import ale.ui.ALEInputText;
import ale.ui.ALEDropDownMenu;
import ale.ui.ALENumericStepper;
import ale.ui.ALETab;

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

var tab:ALETab = new ALETab(50, 50 + ALEUIUtils.OBJECT_SIZE);
add(tab);

var button:ALEButton = new ALEButton(30, 30, 'Siempre');
tab.add(button);
button.releaseCallback = () -> {
    game.camGame.shake(0.0025);
};

var circleButton:ALECircleButton = new ALECircleButton(30, 80, 'Creí', null, false);
tab.add(circleButton);

var inputText:ALEInputText = new ALEInputText(30, 130, ['Fabricio', 'Está Atrás', 'Atrás', 'De nuestra', 'Espalda'], null, null, 'Frase Épica');
tab.add(inputText);

var dropDownMenu:ALEDropDownMenu = new ALEDropDownMenu(30, 180, ['Que', 'Sería', 'Negro']);
tab.add(dropDownMenu);
dropDownMenu.options = ['oso', 'donde', 'tu', 'ta', 'oso'];

var numericStepper:ALENumericStepper = new ALENumericStepper(30, 230);
tab.add(numericStepper);

function onUpdate(elapsed:Float)
{
    if (Controls.RESET && !inputText.isTyping)
        resetCustomState();
}