import flixel.FlxCamera;
import flixel.text.FlxText.FlxTextBorderStyle;

var windowCam = new FlxCamera();
var appCam = new FlxCamera();

var trans:Bool = false;

var clickie:FlxSprite;

function create() {
	FlxG.sound.music.fadeOut(0.3);
	
	windowCam.bgColor = 0x88000000;
	windowCam.alpha = 1;
	windowCam.zoom = 0.5;
	
	appCam.alpha = 0;
	
	trans = true;
	
	windowBase = new FlxSprite(0, 0);
	windowBase.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	windowBase.alpha = 1;
	windowBase.scrollFactor.set();
	windowBase.updateHitbox();
	windowBase.cameras = [windowCam];
	add(windowBase);
	
	appBG = new FlxSprite(0, 0);
	appBG.loadGraphic(Paths.image('menus/gallery/clicker/cookiebg'));
	appBG.alpha = 1;
	appBG.scrollFactor.set();
	appBG.updateHitbox();
	appBG.cameras = [appCam];
	add(appBG);
	
	clickie = new FlxSprite(0, 300).loadGraphic(Paths.image('menus/gallery/clicker/cooki'));
    clickie.scale.set(0.15, 0.15);
    clickie.updateHitbox();
    clickie.screenCenter(0x01);
	clickie.cameras = [appCam];
    add(clickie);
	
	clickstxt = new FunkinText(0, 80, 400, "", 65, true);
	clickstxt.font = Paths.font("Packer-Regular.otf");
	clickstxt.borderSize = 2;
	clickstxt.screenCenter(0x01);
	clickstxt.alignment = "center";
	clickstxt.cameras = [appCam];
	add(clickstxt);
	
	exit = new FlxSprite(FlxG.width - 53, 5).loadGraphic(Paths.image('menus/gallery/close'));
	exit.setGraphicSize(50, 50);
	exit.alpha = 0.8;
	exit.updateHitbox();
	exit.cameras = [appCam];
	add(exit);
	
	FlxTween.tween(windowCam, {zoom: 1}, 0.5, {ease: FlxEase.cubeOut, onComplete: (_) -> 
		loadApp()
	});
}

public static var clickCount:Int = 0;
var bot = Paths.font("vcr.ttf");
function postCreate() {
	FlxG.cameras.add(windowCam, false);
	FlxG.cameras.add(appCam, false);
}

function update(elapsed:Float) {
	if (FlxG.mouse.overlaps(exit) && !trans) {
		exit.alpha = 1;
		if (FlxG.mouse.justPressed) {
			closing = true;
			FlxG.sound.play(Paths.sound("gallery/click"));
			closeWindow();
		}
	} else {
		exit.alpha = lerp(exit.alpha, 0.8, 0.1);
	}
	
	if (FlxG.mouse.overlaps(clickie) && !trans) {
		if (FlxG.mouse.justPressed) {
			FlxG.sound.play(Paths.sound("gallery/click"));
			clickie.scale.set(0.235, 0.235);
			new FlxTimer().start(0.1, ()->{clickCount++;});
		}
	}
	
	clickie.scale.x = lerp(clickie.scale.x, 0.225, 0.2);
	clickie.scale.y = lerp(clickie.scale.y, 0.225, 0.2);
	
	clickstxt.text = "Your Clicks: " + clickCount;
}

function loadApp() {
	FlxTween.tween(appCam, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	trans = false;
	CoolUtil.playMusic(Paths.music("me when the gallery"));
}

function closeWindow() {
	CoolUtil.playMusic(Paths.music("orbindos"));
	FlxG.sound.music.fadeIn(1);
	appCam.alpha = 0;
	FlxTween.tween(windowCam, {alpha: 0}, 0.3, {ease: FlxEase.cubeOut});
	FlxTween.tween(windowCam, {zoom: 0.5}, 0.3, {ease: FlxEase.cubeOut, 
	onComplete: (_) -> close() });
}