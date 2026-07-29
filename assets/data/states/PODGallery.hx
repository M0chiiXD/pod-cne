import openfl.Lib;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.text.FlxText.FlxTextBorderStyle;
import funkin.options.OptionsMenu;
import Date;
import DateTools;

var bg:FlxSprite;
var taskbar:FlxSprite;
var clock:FlxText;
var loadScreen:FlxSprite;
var loadingCam:FlxCamera; // will utilize soon

var transitioning:Bool = false;

var iconDT:Array<String> = [];

public static var lastMenu:String;
public static var justPlayed:Bool;

function create() {
	lastMenu = "Gallery";
	justPlayed = false;
	
    FlxG.mouse.visible = true;
	
	bg = new FlxSprite();
	bg.loadGraphic(Paths.image("menus/gallery/galleryBG"));
	bg.scale.set(1.2, 1.2);
	bg.screenCenter();
    bg.scrollFactor.set(0, 0);

    add(bg);
	
	taskbar = new FlxSprite();
	taskbar.y = FlxG.height - 80;
	taskbar.makeGraphic(FlxG.width, 80, FlxColor.BLACK);
	taskbar.scrollFactor.set();
	taskbar.alpha = 0.85;
	add(taskbar);

	iconDT = [
	makeIcon(42, 60, "overloke", "Overloke"),
	makeIcon(42, 170, "trash", "Trash"),
	makeIcon(42, 280, "metube", "MeTube"),
	makeIcon(42, 390, "cookie", "Cookie Clicker"),
	makeIcon(1200, 60, "baldi", "Baldi's Basics"),
	];
	
	iconTB = [
	makeTaskbarIcon(10, FlxG.height - 80, "curtainsOS"),
	makeTaskbarIcon(120, FlxG.height - 80, "settings")
	];
	
	clock = new FlxText(FlxG.width - 400, FlxG.height - 65, 300, "01:12");
	clock.setFormat("VCR OSD Mono", 40, FlxColor.WHITE, "right");
	clock.borderStyle = FlxTextBorderStyle.OUTLINE;
	clock.borderColor = FlxColor.BLACK;
	clock.borderSize = 2;
	clock.scrollFactor.set(0, 0);
	clock.scale.set(1.3, 1.3);
	clock.updateHitbox();
    add(clock);
	
	if (!justPlayed){
		add(loadScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));
		add(loadtext = new FlxText(0, FlxG.height / 2, 400, "Loading").setFormat("VCR OSD Mono", 30, FlxColor.WHITE, "center").screenCenter(0x01));
		var introWait = new FlxTimer().start(2.5, function(tmr:FlxTimer){ galleryIntro(); });
	} else {
		CoolUtil.playMusic(Paths.music("orbindos"), false);
		FlxG.sound.music.fadeIn(1.8, 0, 0.5);
	}
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
	bt.borderSize = 2;
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
function galleryIntro() {
	loadScreen.destroy();
	add(halfTop = new FlxSprite().makeGraphic(FlxG.width, FlxG.height / 3, FlxColor.BLACK));
	add(halfMid = new FlxSprite(0, 0 + halfTop.height).makeGraphic(FlxG.width, FlxG.height / 3, FlxColor.BLACK));
	add(halfBottom = new FlxSprite(0, 0 + (halfMid.height * 2)).makeGraphic(FlxG.width, FlxG.height / 3, FlxColor.BLACK));
	
	halfTop.destroy();
	var coolStartUp1 = new FlxTimer().start(0.18, function(tmr:FlxTimer){ halfMid.destroy(); });
	var coolStartUp2 = new FlxTimer().start(0.26, function(tmr:FlxTimer){ halfBottom.destroy(); });
	CoolUtil.playMusic(Paths.music("orbindos"), false);
	FlxG.sound.music.fadeIn(1.8, 0, 0.5);
	loadtext.destroy();
	galleryOpen = true;
}

function galleryShutdown() {
	add(endScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000080));
	add(loadtext = new FlxText(0, FlxG.height / 2, 400, "Shutting Down").setFormat("VCR OSD Mono", 30, FlxColor.WHITE, "center").screenCenter(0x01));
	galleryOpen = false;
	var shutdown = new FlxTimer().start(2.3, function(tmr:FlxTimer){ FlxG.switchState(new MainMenuState()); });
	FlxG.sound.music.fadeOut(0.5, 0, 0.5);
}

public static var wallpaper:String = "aero";

function postUpdate(elapsed:Float){
	clock.text = DateTools.format(Date.now(), "%I:%M %p");

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
	
	for (i in 0...iconTB.length) {
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
    }
	
	if (dings > 12) {
		PlayState.loadSong("greeeducation", "normal");
		FlxG.switchState(new PlayState());
	}

	if (controls.BACK) {
		galleryShutdown();
	}
  }
}

function selectApp(index:Int){
	persistentUpdate = !(persistentDraw = true);
	switch (index) {
		case 0: openSubState(new ModSubState("gallerySubstates/overloke"));
		case 1: openSubState(new ModSubState("gallerySubstates/trash"));
		case 2: openSubState(new ModSubState("gallerySubstates/overloke"));
		case 3: openSubState(new ModSubState("gallerySubstates/clicker"));
		case 4: ding();
	}
}

var dings:Int = 0;
function ding() {
	FlxG.sound.play(Paths.sound("gallery/baldi/punch"));
	FlxG.sound.play(Paths.sound("gallery/baldi/ow" + FlxG.random.int(1, 5)));
	FlxG.camera.shake(0.001, 0.1, null, true, FlxAxes.XY);
	dings++;
	trace("ding!");
}