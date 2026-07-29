import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.Lib;

var bg:FlxSprite;
var textBG:FlxSprite;
var creditText:FlxText;
var returnText:FlxText;
var camHover = new FlxCamera();

var icons:Array = [];

var creditList:Array<{icon:String, name:String, link:String, desc:String}> = [];

function create() {
	creditList = Json.parse(Assets.getText(Paths.json("config/credits")));
    FlxG.mouse.visible = true;
	
	camHover.bgColor = 0;
	
	// we need a new bg guys plsplsplspls-
	bg = new FlxSprite(-FlxG.width / 2, -100).loadGraphic("images/credits/icebergBG.png");
	bg.scale.set(4, 5.6);
	bg.updateHitbox();
    add(bg);
	
	for (i in 0...creditList.credits.length) {
		var icon:FlxSprite = new FlxSprite();
		icon.loadGraphic(Paths.image("credits/" + creditList.credits[i].icon));
		icon.scale.set(0.9, 0.9);
		icon.updateHitbox();
		icon.y = 30;
		icon.x = FlxG.random.float(200, 490);
		icon.y = (icon.y + FlxG.random.float(30, 60)) + (i * 140);
		add(icon);
		
		var name = new FlxText();
		name.text = creditList.credits[i].name;
		name.x = icon.x - (icon.width / 3);
		name.y = icon.y + (icon.height - 5);
		name.size = 16;
		name.fieldWidth = 190;
		name.font = Paths.font("PhantomMuff.ttf");
		name.borderStyle = FlxTextBorderStyle.OUTLINE;
		name.borderColor = FlxColor.BLACK;
		name.alignment = "center";
		name.updateHitbox();
		add(name);

		for (t in [name, icon])
			t.cameras = [camHover];

		icons.push(icon);
	}
	
	textBG = new FlxSprite();
    textBG.makeGraphic(100, 50, FlxColor.BLACK);
	textBG.alpha = 0.5;
	textBG.updateHitbox();
    textBG.cameras = [camHover];
    add(textBG);
	
	creditText = new FlxText(0, 0);
	creditText.size = 16;
	creditText.font = Paths.font("scratch-pixel.ttf");
	creditText.updateHitbox();
	creditText.cameras = [camHover];
    add(creditText);
	
	returnText = new FlxText(FlxG.width - 410, FlxG.height + 50);
	returnText.text = "<- Press BACK to return";
	returnText.size = 33;
	returnText.scrollFactor.set();
	returnText.font = Paths.font("PhantomMuff.ttf");
	returnText.updateHitbox();
    add(returnText);
	
	FlxTween.tween(returnText, {y: FlxG.height - 50}, 1.3, {ease: FlxEase.cubeInOut});
	CoolUtil.playMusic(Paths.music("silly the second"));
}

function postCreate() {
	FlxG.cameras.add(camHover, false);
}

var scrollY:Float = 0;
function update(elapsed:Float) {
	if (controls.BACK) {
			FlxG.switchState(new MainMenuState());
	}
	
	textBG.visible = creditText.visible;
	textBG.scale.set(creditText.fieldWidth / 98, 1);
	textBG.updateHitbox();
	creditText.visible = false;

	for (i in 0...icons.length) {
		if (FlxG.mouse.overlaps(icons[i])) {
			icons[i].scale.set(0.93, 0.93);
			selectIndex = i;
			creditText.text = creditList.credits[i].desc;
			creditText.visible = true;
				if (FlxG.mouse.justPressed) {
					CoolUtil.openURL(creditList.credits[i].link);
				}
		} else {
			icons[i].scale.x = lerp(icons[i].scale.x, 0.9, 0.1);
			icons[i].scale.y = lerp(icons[i].scale.y, 0.9, 0.1);
		}
	}
	
	FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, (scrollY = FlxMath.bound(FlxG.mouse.wheel != 0 ? scrollY - FlxG.mouse.wheel * 60 : scrollY, 0, creditList.credits.length * 78)), 0.1);
	camHover.scroll.y = lerp(FlxG.camera.scroll.y, (scrollY = FlxMath.bound(FlxG.mouse.wheel != 0 ? scrollY - FlxG.mouse.wheel * 60 : scrollY, 0, creditList.credits.length *  78)), 0.1);
	
	creditText.setPosition((FlxG.mouse.x - camHover.x) + 20, FlxG.mouse.y - camHover.y);
	textBG.setPosition(creditText.x - 3, creditText.y);
}