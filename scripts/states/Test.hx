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

var tab:ALETab = new ALETab(100, 350 + ALEUIUtils.OBJECT_SIZE);
add(tab);

var button:ALEButton = new ALEButton(100, 100, 'Siempre');
tab.content.add(button);
button.releaseCallback = () -> {
    game.camGame.shake(0.0025);
};

var circleButton:ALECircleButton = new ALECircleButton(100, 150, 'Creí', 30, false);
tab.content.add(circleButton);

var inputText:ALEInputText = new ALEInputText(100, 200, ['Fabricio', 'Está Atrás', 'Atrás', 'De nuestra', 'Espalda'], null, null, 'Frase Épica');
tab.content.add(inputText);

var dropDownMenu:ALEDropDownMenu = new ALEDropDownMenu(100, 250, ['Que', 'Sería', 'Negro']);
tab.content.add(dropDownMenu);
dropDownMenu.options = ['oso', 'donde', 'tu', 'ta', 'oso'];

var numericStepper:ALENumericStepper = new ALENumericStepper(100, 300);
tab.content.add(numericStepper);

function onUpdate(elapsed:Float)
{
    if (Controls.RESET && !inputText.isTyping)
        resetCustomState();
}