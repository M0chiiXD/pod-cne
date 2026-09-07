import sys.FileSystem;
import lime.utils.Assets;
import haxe.Json;
import haxe.io.Path;
import flixel.util.FlxStringUtil;
import flixel.group.FlxTypedGroup;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.system.Control;
import funkin.backend.system.Controls;
import funkin.backend.utils.ControlsUtil;
import funkin.backend.chart.Chart;
import funkin.backend.MusicBeatState;
import funkin.savedata.FunkinSave;
import funkin.menus.FreeplaySonglist;
import funkin.options.OptionsMenu;
import hxvlc.flixel.FlxVideoSprite;
import openfl.display.BlendMode;

public static var lastMenu:String;
public static var justPlayed:Bool;

var songs = FreeplaySonglist.get().songs;
var songCover:FlxSprite;

var camUI:FlxCamera = new FlxCamera();

var phant = Paths.font("PhantomMuff.ttf");
var curSelected:Int = 0;
var curDifficulty:Int = 1;

var vert:CustomShader = new CustomShader("rayMarch");
var curve:CustomShader = new CustomShader("rayMarch");

var canSelect:Bool = false;

function create() {
	DiscordUtil.call("onMenuLoaded", ["Freeplay"]);
	
	camUI.bgColor = 0;
	camUI.useBgAlphaBlending = true;
	FlxG.cameras.add(camUI, false);

	FlxG.camera.addShader(new CustomShader('perspective'));

	PlayState.isStoryMode = false;

	lastMenu = "Freeplay";
	
	doorL = new FlxSprite().loadGraphic(Paths.image("menus/sigmavator/doorL"));
	doorL.updateHitbox();
	doorL.antialiasing = Options.antialiasing;
	add(doorL);
	
	doorR = new FlxSprite().loadGraphic(Paths.image("menus/sigmavator/doorR"));
	doorR.antialiasing = Options.antialiasing;
	add(doorR);

	elevator = new FlxSprite().loadGraphic(Paths.image("menus/sigmavator/elevatorBG"));
	elevator.setGraphicSize(FlxG.width, FlxG.height);
	elevator.updateHitbox();
	elevator.antialiasing = Options.antialiasing;
	add(elevator);

	elevLight = new FlxSprite().loadGraphic(Paths.image("menus/sigmavator/elevatorGlow"));
	elevLight.setGraphicSize(FlxG.width, FlxG.height);
	elevLight.blend = BlendMode.ADD;
	elevLight.updateHitbox();
	elevLight.antialiasing = Options.antialiasing;
	add(elevLight);
	FlxTween.tween(elevLight, {alpha: elevLight.alpha - 0.5}, 1, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

	chair = new FlxSprite(120, 480).loadGraphic(Paths.image("menus/sigmavator/stool"));
	chair.scale.set(0.6, 0.6);
	chair.scrollFactor.set(1.15, 1.15);
	chair.updateHitbox();
	chair.antialiasing = Options.antialiasing;
	add(chair);
	
	infoTxt = new FlxText(946, 230, 300).setFormat(Paths.font("scratch-pixel.ttf"), 28, FlxColor.WHITE, "center");
	infoTxt.updateHitbox();
    add(infoTxt);
	infoTxt.shader = vert;
	vert.rotation = [0, 0.35, 0];
	
	cBar = new FlxSprite(0, FlxG.height).makeSolid(1280, 85, FlxColor.BLACK).screenCenter(FlxAxes.X);
	cBar.camera = camUI;
	add(cBar);

	var up = controls.getKeyName(Control.UP);
	var down = controls.getKeyName(Control.DOWN);
	var left = controls.getKeyName(Control.LEFT);
	var right = controls.getKeyName(Control.RIGHT);
	var mix = CoolUtil.keyToString(ControlsUtil.getControl(controls, "mixes"));

	controlstxt = new FlxText(10, 0, 2000, up + "/" + down +
	" to switch songs, " + left + "/" + right + " to switch difficulty | " + mix + " to switch mixes");
    controlstxt.setFormat(phant, 30, FlxColor.WHITE, "left");
	controlstxt.scrollFactor.set(0, 0);
	controlstxt.camera = camUI;
	controlstxt.updateHitbox();
    add(controlstxt);
	
	titleSign = new FunkinSprite(0, 0, Paths.image("menus/sigmavator/titleSign"));
	titleSign.scale.set(0.8, 0.8);
	titleSign.updateHitbox();
	titleSign.addAnim("idle", "idle0", 1, true);
	titleSign.addAnim("static", "static", 24, true);
	titleSign.scrollFactor.set(1.2, 1.2);
	titleSign.screenCenter(FlxAxes.X);

	songCover = new FlxSprite();
	songCover.loadGraphic(Paths.image("menus/freeplay/songCovers/" + songs[curSelected].name));
	songCover.scale.set(0.78, 0.78);
	songCover.scrollFactor.set(1.35, 1.35);
	songCover.updateHitbox();
	songCover.screenCenter(FlxAxes.X);
	songCover.y = 108;
	songCover.visible = false;

	titleSign.shader = songCover.shader = curve;

	add(songCover);
	add(titleSign);
	
	titleSign.playAnim("static");

/*	filter = new FlxSprite(0, 0);
	filter.loadGraphic(Paths.image("menus/freeplay/filter"));
	filter.updateHitbox();
	filter.antialiasing = Options.antialiasing;
	add(filter);
	
	filterEvil = new FlxSprite(0, 0);
	filterEvil.loadGraphic(Paths.image("menus/freeplay/filterEvil"));
	filterEvil.updateHitbox();
	filterEvil.antialiasing = Options.antialiasing;
	add(filterEvil);*/
	
	curDifficulty = 0;
	
/*	for (locked in ["skibidi-war", "greeducation"])
        if (FunkinSave.getSongHighscore(i, "normal").score == 0)
            playable = false;
    }*/
}

function postCreate() {
	//the intro stuff
	lockCam = true;

	if (justPlayed) {
		FlxG.camera.zoom = 3;
		new FlxTimer().start(0.5, function(tmr:FlxTimer){
			FlxG.camera.shake(0.0015, 0.5, null, true, FlxAxes.XY);
		});
		doorL.x = 50;
		doorR.x = 945;
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.8, {ease: FlxEase.sineOut});
		FlxTween.tween(doorL, {x: 418}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(doorR, {x: 637}, 0.8, {ease: FlxEase.quartOut});
		FlxG.sound.play(Paths.sound("freeplay/freeplayEnter1"));
		justPlayed = false;
	} else {
		doorL.x = 418;
		doorR.x = 637;
		FlxG.camera.zoom = 0.75;
		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, {zoom: 1.05, alpha: 1}, 0.5, {ease: FlxEase.expoOut});
		FlxG.sound.play(Paths.sound("freeplay/freeplayEnter2"));
	}
	
	titleSign.y = -300;
	FlxTween.cancelTweensOf(titleSign);
	FlxTween.cancelTweensOf(songCover);
	FlxTween.tween(titleSign, {y: -85}, 1, {ease: FlxEase.expoOut,
		onComplete: (_) -> {
			songCover.visible = true;
			FlxTween.tween(cBar, {y: 670}, 0.5, {ease: FlxEase.circOut});
			titleSign.playAnim("idle");
			lockCam = false;
		}
	});
	
	new FlxTimer().start(1, function(tmr:FlxTimer){ canSelect = true; });
	
	CoolUtil.playMusic(Paths.music("freeplay menu song called freeplay"), false);	
	FlxG.sound.music.fadeIn(1, 0, 0.25);
}

var scoreLerp;
function update(elapsed:Float) {	
	var songData = FunkinSave.getSongHighscore(songs[curSelected].name, (songs[curSelected].difficulties[curDifficulty]));
	var accuracy = Math.round(songData.accuracy * 100);

//	dRating.playAnim(getSongRank(accuracy));

	controlstxt.y = cBar.y + 6;

	songCover.loadGraphic(Paths.image("menus/freeplay/songCovers/" + songs[curSelected].name));

	updateCamera(elapsed);

	curve.rotation = [0, -(FlxG.camera.scroll.x * 0.0008), 0];

	infoTxt.text =
	(songData.score == 0 ? "N/A" : Std.string(songData.score)) + "\n" +
	FlxMath.roundDecimal(Math.max(songData.accuracy, 0) * 100, 2) + "%"  + "\n" +
	"< " + songs[curSelected].difficulties[curDifficulty] + " >";

	if (canSelect) {
		if (controls.UP_P || controls.DOWN_P) changeSelection(controls.UP_P ? -1 : 1);
		if (controls.LEFT_P || controls.RIGHT_P) changeDiff(controls.LEFT_P ? -1 : 1);
		if (controls.ACCEPT) songLoad(curSelected);
		if (controls.BACK) {
			songCover.visible = false;
			FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.2 }, 0.5);
			FlxTween.tween(FlxG.camera, {zoom: 0.9, alpha: 0}, 0.5, {ease: FlxEase.quartOut});

			FlxTween.cancelTweensOf(titleSign);
			FlxTween.cancelTweensOf(cBar);
			FlxTween.tween(titleSign, {y: -236}, 0.7, {ease: FlxEase.backOut});
			FlxTween.tween(cBar, {y: 720}, 0.2, {ease: FlxEase.circIn});
			FlxG.sound.play(Paths.sound("freeplay/freeplayExit"));
			new FlxTimer().start(1, function(tmr:FlxTimer){
				FlxG.switchState(new MainMenuState());
			});
		}
	}
}

var lockCam:Bool = false;

// // took this from vanity's fnaf 2 cne port lols!!
var camBaseX:Float;
var deadZone:Float = 150; // center area where camera doesn't move
var camRangeX:Float = 50; // max left/right movement
function updateCamera(elapsed:Float){
	if (lockCam) return;

	var mouseX = FlxG.mouse.screenX;
	var centerX = FlxG.width / 2;
	var mouseOffset = mouseX - centerX;
	var moveSpeed:Float = 0;

	if (Math.abs(mouseOffset) > deadZone) {
		var distance = Math.abs(mouseOffset) - deadZone;
		var strength = distance / (centerX - deadZone);
		strength *= 2;
		strength = FlxMath.bound(strength, 0, 1);
		moveSpeed = FlxMath.signOf(mouseOffset) * strength * 210;
	}

	FlxG.camera.scroll.x += moveSpeed * elapsed;
	FlxG.camera.scroll.x = FlxMath.bound(FlxG.camera.scroll.x, camBaseX - 30, 0);
}

function getSongRank(acc:Int):String {
	if (acc >= 95) {
		return "6";
	} else if (acc >= 85) {
		return "5";
	} else if (acc >= 75) {
		return "4";
	} else if (acc >= 65) {
		return "3";
	} else if (acc == 50) {
        return "2";
	} else {
		return "1";
	}
}

var item = songs[curSelected];
function changeSelection(change) {
	canSelect = songCover.visible = false;
	titleSign.playAnim("static");

    curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);

	new FlxTimer().start(0.2, function(tmr:FlxTimer){
		canSelect = songCover.visible = true;
		titleSign.playAnim("idle");
	});

	FlxG.sound.play(Paths.sound("freeplay/scroll"), 1);
	FlxG.camera.shake(0.002, 0.1, null, true, FlxAxes.Y);
	if (curDifficulty == null) curDifficulty = 0;
}

function changeDiff(change) {
	curDifficulty = FlxMath.wrap(curDifficulty + change, 0, item.difficulties.length - 1);
	
	if (item.difficulties.length <= 0) {
		FlxG.sound.play(Paths.sound("freeplay/diffNull"));
		FlxG.camera.shake(0.0025, 0.1, null, true, FlxAxes.X);
	} else if (item.difficulties.length >= 1) {
		FlxG.sound.play(Paths.sound("freeplay/diffSwitch"));
	}
}

function songLoad(cur:Int) {
	canSelect = false;
	PlayState.loadSong(songs[cur].name, (songs[cur].difficulties[curDifficulty]));
	
	FlxG.camera.scroll.x = 0;
	titleSign.playAnim("static");
	lockCam = true;

	FlxTween.cancelTweensOf(cBar);
	FlxTween.tween(FlxG.camera, {"scroll.y": 40, zoom: 1.5}, 0.2, {ease: FlxEase.sineOut});
	FlxTween.tween(cBar, {y: 720}, 0.5, {ease: FlxEase.circIn});

	if (curDifficulty == 0) {
		FlxG.sound.play(Paths.sound("freeplay/songSelect"));
	} else {
		FlxG.sound.play(Paths.sound("freeplay/evilSelect"));
	}

	FlxTween.cancelTweensOf(titleSign);
	titleSign.y = -90;
	FlxTween.tween(titleSign, {y: -200}, 1, {ease: FlxEase.backIn});
	songCover.visible = false;
	
	FlxG.camera.shake(0.0015, 0.5, null, true, FlxAxes.XY);
	FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.3 }, 2);
	FlxTween.tween(doorL, {x: doorL.x - 230}, 0.85, {ease: FlxEase.circIn});
	FlxTween.tween(doorR, {x: doorR.x + 230}, 0.85, {ease: FlxEase.circIn});

	new FlxTimer().start(0.2, function(tmr:FlxTimer){
		FlxTween.tween(FlxG.camera, {zoom: 6.5}, 2, {ease: FlxEase.expoIn, onComplete: function() {
			FlxG.switchState(new PlayState());
		}
		});
	});
}
