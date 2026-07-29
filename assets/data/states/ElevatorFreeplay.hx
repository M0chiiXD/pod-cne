import sys.FileSystem;
import lime.utils.Assets;
import haxe.Json;
import haxe.io.Path;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import flixel.group.FlxTypedGroup;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.system.Controls;
import funkin.backend.chart.Chart;
import funkin.backend.MusicBeatState;
import funkin.savedata.FunkinSave;
import funkin.menus.FreeplaySonglist;
import funkin.options.OptionsMenu;
import hxvlc.flixel.FlxVideoSprite;

public static var lastMenu:String;
public static var justPlayed:Bool;

var songs = FreeplaySonglist.get().songs;
var songCover:FlxSprite;

var phant = Paths.font("PhantomMuff.ttf");
var curSelected:Int = 0;
var curDifficulty:Int = 1;

var canSelect:Bool = false;

function create() {
	DiscordUtil.call("onMenuLoaded", ["Freeplay"]);
	
	PlayState.isStoryMode = false;

	lastMenu = "Freeplay";
	
	doorL = new FlxSprite();
	doorL.loadGraphic(Paths.image("menus/freeplay/door"));
	doorL.flipX = true;
	doorL.updateHitbox();
	doorL.antialiasing = Options.antialiasing;
	add(doorL);
	
	doorR = new FlxSprite();
	doorR.loadGraphic(Paths.image("menus/freeplay/door"));
	doorR.antialiasing = Options.antialiasing;
	add(doorR);
	
	center = new FlxSprite(-3, -10);
	center.loadGraphic(Paths.image("menus/freeplay/elevator"));
	center.scale.set(1.01, 1.01);
	center.antialiasing = Options.antialiasing;
	insert(5, center);
	
	screenT = new FlxSprite(0, -20);
	screenT.loadGraphic(Paths.image("menus/freeplay/screen"));
	screenT.screenCenter(FlxAxes.X);
	screenT.scale.set(1, 0.835);
	screenT.updateHitbox();
	screenT.antialiasing = Options.antialiasing;
	
	screenSd = new FlxSprite(0, 0);	screenSd.loadGraphic(Paths.image("menus/freeplay/sidePanel"));
	screenSd.screenCenter(FlxAxes.X);
	screenSd.updateHitbox();
	screenSd.antialiasing = Options.antialiasing;
	add(screenSd);
	
	cBar = new FlxSprite(0, 0).makeSolid(1280, 85, FlxColor.BLACK);
	cBar.screenCenter(FlxAxes.X);
	cBar.y = 670;
	add(cBar);
	
	scoretxt = new FlxText(FlxG.width - 260, 350, 300, "69420");
	scoretxt.setFormat(phant, 38, FlxColor.WHITE, "center");
	scoretxt.scrollFactor.set(0, 0);
	scoretxt.updateHitbox();
    add(scoretxt);
	
	difftxt = new FlxText(FlxG.width - 205, 390, 200, "b");
	difftxt.setFormat(phant, 30, FlxColor.WHITE, "center");
	difftxt.scrollFactor.set(0, 0);
	difftxt.updateHitbox();
    add(difftxt);
	
	dRating = new FunkinSprite(FlxG.width - 183, 450, Paths.image("menus/freeplay/diffRating"));
	dRating.animation.addByPrefix("1", "10000", 2, true);
	dRating.animation.addByPrefix("2","20000", 2, true);
	dRating.animation.addByPrefix("3", "30000", 2, true);
	dRating.animation.addByPrefix("4","40000", 2, true);
	dRating.animation.addByPrefix("5", "50000", 2, true);
	dRating.animation.addByPrefix("6","60000", 2, true);
	dRating.scale.set(0.28, 0.28);
	dRating.updateHitbox();
    add(dRating);
	
	acctxt = new FlxText(FlxG.width - 205, 520, 205, "b");
	acctxt.setFormat(phant, 30, FlxColor.WHITE, "center");
	acctxt.scrollFactor.set(0, 0);
	acctxt.updateHitbox();
    add(acctxt);
	
	controlstxt = new FlxText(10, FlxG.height - 45, 2000, 
	"Up/Down to switch songs | Left/Right to switch difficulty | TAB to switch mixes");
    controlstxt.setFormat(phant, 30, FlxColor.WHITE, "left");
	controlstxt.scrollFactor.set(0, 0);
	controlstxt.updateHitbox();
    add(controlstxt);
	
	songCover = new FlxSprite();
	songCover.loadGraphic(Paths.image("menus/freeplay/songCovers/" + songs[curSelected].name));
	songCover.scale.set(1.42, 1.42);
	songCover.updateHitbox();
	songCover.screenCenter();
	songCover.y = defPos;
	add(songCover);
	
	add(screenT);
	
	filter = new FlxSprite(0, 0);
	filter.loadGraphic(Paths.image("menus/freeplay/filter"));
	filter.updateHitbox();
	filter.antialiasing = Options.antialiasing;
	add(filter);
	
	filterEvil = new FlxSprite(0, 0);
	filterEvil.loadGraphic(Paths.image("menus/freeplay/filterEvil"));
	filterEvil.updateHitbox();
	filterEvil.antialiasing = Options.antialiasing;
	add(filterEvil);
	
	curDifficulty = 0;
	
/*	for (locked in ["skibidi-war", "greeducation"])
        if (FunkinSave.getSongHighscore(i, "normal").score == 0)
            playable = false;
    }*/
}

function postCreate() {
	//the intro stuff
	if (justPlayed) {
		FlxG.camera.zoom = 3;
		doorL.x = 45;
		doorR.x = 940;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(doorL, {x: 350}, 0.8, {ease: FlxEase.quartOut});
		FlxTween.tween(doorR, {x: 640}, 0.8, {ease: FlxEase.quartOut});
		FlxG.sound.play(Paths.sound("freeplay/freeplayEnter1"));
		justPlayed = false;
	} else {
		doorL.x = 350;
		doorR.x = 640;
		FlxG.camera.zoom = 0.6;
		FlxG.camera.alpha = 0;
		FlxTween.tween(FlxG.camera, {zoom: 1, alpha: 1}, 0.8, {ease: FlxEase.quartOut});
		FlxG.sound.play(Paths.sound("freeplay/freeplayEnter2"));
	}
	
	screenT.y = -236;
	songCover.y = -200;
	FlxTween.cancelTweensOf(screenT);
	FlxTween.cancelTweensOf(songCover);
	FlxTween.tween(screenT, {y: -20}, 1, {ease: FlxEase.backOut});
	FlxTween.tween(songCover, {y: defPos}, 1, {ease: FlxEase.backOut});
	
	new FlxTimer().start(1, function(tmr:FlxTimer){ canSelect = true; });
	
	CoolUtil.playMusic(Paths.music("freeplay menu song called freeplay"), false);	
	FlxG.sound.music.fadeIn(1, 0, 0.8);
}

var scoreLerp;
function update(elapsed:Float) {	
	var songData = FunkinSave.getSongHighscore(songs[curSelected].name, (songs[curSelected].difficulties[curDifficulty]));
	var accuracy = Math.round(songData.accuracy * 100);

	dRating.playAnim(getSongRank(accuracy));
	
/*	scoreLerp = FlxMath.lerp(scoreLerp, songData.score, 0.1);
	scoretxt.text = Std.parseInt(scoreLerp);*/
	scoretxt.text = (songData.score == 0 ? "N/A" : Std.string(songData.score));
	difftxt.text = "< " + songs[curSelected].difficulties[curDifficulty] + " >";
	acctxt.text = FlxMath.roundDecimal(Math.max(songData.accuracy, 0) * 100, 2) + "%";
	
	songCover.loadGraphic(Paths.image("menus/freeplay/songCovers/" + songs[curSelected].name));
	
	for (uiPanel in [scoretxt, difftxt, dRating, acctxt]) {
		if (curDifficulty == 0) {
			uiPanel.color = FlxColor.GREEN;
			filterEvil.visible = false;
			filter.visible = true;
		} else {
			uiPanel.color = FlxColor.RED;
			filterEvil.visible = true;
			filter.visible = false;
		}
	}

	if (canSelect) {
		if (controls.UP_P || controls.DOWN_P) changeSelection(controls.UP_P ? -1 : 1);
		if (controls.LEFT_P || controls.RIGHT_P) {
			changeDiff(controls.LEFT_P ? -1 : 1);
		}
		if (controls.ACCEPT) songLoad(curSelected);
		if (controls.BACK) {
			FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.2 }, 0.5); 
			FlxTween.tween(FlxG.camera, {zoom: 0.8, alpha: 0}, 0.5, {ease: FlxEase.quartOut});
			FlxTween.cancelTweensOf(screenT);
			FlxTween.cancelTweensOf(songCover);
			FlxTween.tween(screenT, {y: -236}, 0.7, {ease: FlxEase.backOut});
			FlxTween.tween(songCover, {y: -200}, 0.7, {ease: FlxEase.backOut});
			FlxG.sound.play(Paths.sound("freeplay/freeplayExit"));
			new FlxTimer().start(1, function(tmr:FlxTimer){
				FlxG.switchState(new MainMenuState());
			});
		}
	}
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

var defPos:Int = 23;
function changeSelection(change) {
    curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
	var item = songs[curSelected];
	
	FlxG.sound.play(Paths.sound("freeplay/scroll"), 1);
	
	FlxG.camera.shake(0.002, 0.1, null, true, FlxAxes.Y);
	
	FlxTween.cancelTweensOf(screenT);
	FlxTween.cancelTweensOf(songCover);
	FlxTween.tween(screenT, {y: -10}, 0.0001, {ease: FlxEase.circOut, onComplete: function() {
	FlxTween.tween(screenT, { y: -20}, 1, {ease: FlxEase.circOut});
	}
	});
	FlxTween.tween(songCover, {y: defPos + 10}, 0.0001, {ease: FlxEase.circOut, onComplete: function() {
	FlxTween.tween(songCover, { y: defPos }, 0.8, {ease: FlxEase.circOut});
	}
	});
	
	if (item.difficulties == null) curDifficulty = 0;
}

function changeDiff(change) {
	var item = songs[curSelected];
	curDifficulty = FlxMath.wrap(curDifficulty + change, 0, item.difficulties.length - 1);
	
	if (item.difficulties.length <= 1) {
		FlxG.sound.play(Paths.sound("freeplay/diffNull"));
		FlxG.camera.shake(0.0025, 0.1, null, true, FlxAxes.X);
	} else if (item.difficulties.length >= 1) {
		FlxG.sound.play(Paths.sound("freeplay/diffSwitch"));
	}
}

function songLoad(cur:Int) {
	canSelect = false;
	PlayState.loadSong(songs[cur].name, (songs[cur].difficulties[curDifficulty]));
	
	if (curDifficulty == 0) {
		FlxG.sound.play(Paths.sound("freeplay/songSelect"));
	} else {
		FlxG.sound.play(Paths.sound("freeplay/evilSelect"));
	}
	FlxTween.cancelTweensOf(screenT);
	FlxTween.cancelTweensOf(songCover);
	FlxTween.tween(screenT, { y: -20}, 0.001, {ease: FlxEase.circOut});
	FlxTween.tween(songCover, { y: defPos }, 0.001, {ease: FlxEase.circOut});
	FlxTween.tween(screenT, {y: -236}, 1, {ease: FlxEase.backIn});
	FlxTween.tween(songCover, {y: -200}, 1, {ease: FlxEase.backIn});
	
	FlxG.camera.shake(0.0015, 0.5, null, true, FlxAxes.XY);
	FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.3 }, 0.8); 
	FlxTween.tween(doorL, {x: doorL.x - 235}, 1, {ease: FlxEase.cubeIn});
	FlxTween.tween(doorR, {x: doorR.x + 230}, 1, {ease: FlxEase.cubeIn});
	
	FlxTween.tween(FlxG.camera, {zoom: 3}, 2.3, {ease: FlxEase.circIn, onComplete: function() {
		FlxG.switchState(new PlayState());
		}
	});
}
