import openfl.Lib;
import openfl.filters.BlurFilter;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import funkin.options.OptionsMenu;
import Date;
import DateTools;
import flixel.FlxLayer;
import curtainsOS.BasicWindow;
import curtainsOS.OSButton;
//importScript("data/scripts/test");

var bg:FlxSprite;
var taskbar:FlxSprite;
var clock:FlxText;
var loadScreen:FlxSprite;
var loadingCam:FlxCamera; // will utilize soon

var transitioning:Bool = false;
var iconDT:Array<String> = [];
var blur:CustomShader = new CustomShader("blur");

var curWindow;
var windowArray:Array<Dynamic> = [];
var windowLayer:FlxLayer;

public static var lastMenu:String;
public static var justPlayed:Bool;

function create() {
	lastMenu = "Gallery";
	justPlayed = false;

    FlxG.mouse.visible = true;

	bg = new FlxSprite();
	bg.loadGraphic(Paths.image("menus/gallery/galleryBGaero"));
	bg.scale.set(1.2, 1.2);
	bg.screenCenter();
    bg.scrollFactor.set(0, 0);
    add(bg);

	var blurFilter = new BlurFilter(4, 4, 1);

	iconDT = [
		makeIcon(42, 60, "trash", "Trash"),
		makeIcon(42, 170, "overloke", "Overloke"),
		makeIcon(42, 280, "metube", "MeTube"),
		makeIcon(42, 390, "cookie", "Cookie Clicker"),
		makeIcon(1200, 60, "baldi", "Baldi's Basics"),
	];

	/* iconTB = [
	makeTaskbarIcon(10, FlxG.height - 80, "curtainsOS"),
	makeTaskbarIcon(120, FlxG.height - 80, "settings")
	]; */

	blur.strength = 1;

	mainLayer = new FlxCamera();
	mainLayer.bgColor = 0;
	topLayer = new FlxCamera();
	topLayer.bgColor = 0;
	FlxG.cameras.add(mainLayer, false);
	FlxG.cameras.add(topLayer, false);

	taskbar = new FlxSprite();
	taskbar.y = FlxG.height - 50;
	taskbar.makeGraphic(FlxG.width, 50, FlxColor.BLACK);
	taskbar.shader = blur;
	taskbar.scrollFactor.set();
	taskbar.alpha = 0.65;
	add(taskbar);

	clock = new FlxText(FlxG.width - 240, FlxG.height - 48, 250, "01:12");
	clock.setFormat(Paths.font("Segoe/Segoe UI.ttf"), 13.5, FlxColor.WHITE, "center");
	clock.scrollFactor.set(0, 0);
	clock.scale.set(1.3, 1.3);
	clock.updateHitbox();
    add(clock);

	CoolUtil.playMusic(Paths.music("orbindos"), false);
	FlxG.sound.music.fadeIn(1.8, 0, 0.5);
	galleryOpen = true;
}

function makeIcon(xBtn:Float, yBtn:Float, text:String, name:String) {
    var b = new FlxSprite().loadGraphic(Paths.image('menus/gallery/' + text));
	b.scrollFactor.set(0, 0);
	b.scale.set(0.6, 0.6);
	b.updateHitbox();
	b.x = xBtn;
	b.y = yBtn;
	b.alpha = 1;
    add(b);

	var bt = new FlxText(xBtn - 20, yBtn + 64, 170, name);
	bt.setFormat("VCR OSD Mono", 22, FlxColor.WHITE, "center");
	bt.borderStyle = FlxTextBorderStyle.OUTLINE;
	bt.borderColor = FlxColor.BLACK;
	bt.borderSize = 1;
	bt.scrollFactor.set(0, 0);
	bt.scale.set(0.6, 0.6);
	bt.updateHitbox();
	bt.alpha = 1;
    add(bt);

    return b;
    return bt;
}

function makeTaskbarIcon(xBtn:Float, yBtn:Float, text:String) {
    var t = new FlxSprite().loadGraphic(Paths.image('menus/gallery/' + text));
	t.scrollFactor.set(0, 0);
	t.scale.set(0.63, 0.63);
	t.updateHitbox();
	t.x = xBtn;
	t.y = yBtn;
	t.alpha = 1;
    add(t);
    return t;
}

var galleryOpen = false;

public static var wallpaper:String = "aero";

function postUpdate(elapsed:Float){
	clock.text = DateTools.format(Date.now(), "%H:%M %p\n%m/%d/%Y");

	if (FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound("gallery/click"));
	}

	if (galleryOpen){
		for (i in 0...iconDT.length) {
			if (FlxG.mouse.overlaps(iconDT[i]) && !transitioning) {
				iconDT[i].scale.set(0.63, 0.63);
				selectIndex = i;
					if (FlxG.mouse.justPressed) {
						selectApp(selectIndex);
					}
			} else {
				iconDT[i].scale.x = lerp(iconDT[i].scale.x, 0.6, 0.1);
				iconDT[i].scale.y = lerp(iconDT[i].scale.y, 0.6, 0.1);
				hovered = false;
			}
	}

	for (i in 0...windowArray.length) {
		if (FlxG.mouse.overlaps(windowArray[i]) && FlxG.mouse.pressed) {
			var thinkg = windowArray[i];
			remove(thinkg);
			add(thinkg);
		}
	}


/*	for (i in 0...iconTB.length) {
        if (FlxG.mouse.overlaps(iconTB[i]) && !transitioning) {
			iconTB[i].scale.x = 0.62;
			iconTB[i].scale.y = 0.62;
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(iconTB[0])) {
					galleryShutdown();
				} else if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(iconTB[1])) {
					persistentUpdate = !(persistentDraw = true);
					openSubState(new ModSubState("gallerySubstates/settings"));
				}
		} else {
			iconTB[i].scale.x = lerp(iconTB[i].scale.x, 0.6, 0.1);
			iconTB[i].scale.y = lerp(iconTB[i].scale.y, 0.6, 0.1);
			hovered = false;
		}
    }*/

	if (dings > 12) {
		PlayState.loadSong("greeeducation", "normal");
		FlxG.switchState(new PlayState());
	}

	if (controls.BACK) {
		FlxG.switchState(new MainMenuState());
	}
  }
}

function selectApp(index:Int){
	persistentUpdate = !(persistentDraw = true);
	switch (index) {
		case 0: runWindow("Trash Bin");
		case 1: openSubState(new ModSubState("gallerySubstates/overloke"));
		case 2: openSubState(new ModSubState("gallerySubstates/overloke"));
		case 3: openSubState(new ModSubState("gallerySubstates/clicker"));
		case 4: ding();
	}
}

function runWindow(title:String) {
	var window = new BasicWindow(50, 30, 864, 490, title);
	window.scale.set(0.9, 0.9);
	add(window);

	window.borderColor = FlxColor.GREEN;
	FlxTween.tween(window, {"scale.x": 1, "scale.y": 1}, 0.25, {ease: FlxEase.circOut});
	windowArray.push(window);
	return(window);
}

var dings:Int = 0;
function ding() {
	FlxG.sound.play(Paths.sound("gallery/baldi/punch"));
	FlxG.sound.play(Paths.sound("gallery/baldi/ow" + FlxG.random.int(1, 5)));
	FlxG.camera.shake(0.001, 0.1, null, true, FlxAxes.XY);
	dings++;
	trace("ding!");
}
