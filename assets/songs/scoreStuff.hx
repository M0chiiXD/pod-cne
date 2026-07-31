import flixel.util.FlxStringUtil;
import funkin.game.PlayState;
import funkin.game.PlayState.ComboRating;
import haxe.ds.ObjectMap;
import funkin.options.Options;
import funkin.savedata.FunkinSave;
import funkin.savedata.HighscoreChange;
import Date;

PauseSubState.script = 'data/scripts/podpausemenu';
GameOverSubstate.script = 'data/scripts/gameover/gameOver';

public static var justPlayed:Bool;

allowGitaroo = false;

var zeroLengthSongs:Array<String> = ["burned", "carnivorous", "greeeducation"];

function create(){
	introLength = 1; 
	for (item in zeroLengthSongs) {
		if (PlayState.SONG.meta.name.toLowerCase() == item) { 
			introLength = 0; 
		}
	}

	justPlayed = true;
}

function onCountdown(event:CountdownEvent) event.cancel();
function onStrumCreation(_) _.__doAnimation = false;

function postCreate() {
	doIconBop = false;

	if (downscroll){
//	  healthBarBG?.offset.y = -9;
	  missesTxt.y = 610;
	}
	
	healthBar.numDivisions = 1000;
	
	FlxG.camera.zoom = defaultCamZoom;
}

function beatHit() {
	for (icons in [iconP1, iconP2]) {
		FlxTween.cancelTweensOf(icons);
		icons.scale.set(1.25, 1.25);
		FlxTween.tween(icons, {"scale.x": 1, "scale.y": 1}, 0.12, {ease: FlxEase.circOut});
	}
	
	var turnIt:Int = 20;
	if (curBeat % 2 == 0){
		turnIt = -turnIt;
	}
	
	iconP1.angle = turnIt;
	iconP2.angle = -turnIt;
	FlxTween.tween(iconP1, {angle: 0}, 0.2, {ease: FlxEase.circOut});
	FlxTween.tween(iconP2, {angle: 0}, 0.2, {ease: FlxEase.circOut});
}

public static var lastMenu:String;
function onSongEnd(event){	
	// idk guys
	if (!PlayState.chartingMode){
		event.cancel();
		
		if (validScore) {
			#if !switch
			FunkinSave.setSongHighscore(PlayState.SONG.meta.name, PlayState.difficulty, PlayState.variation, {
			score: songScore,
			misses: misses,
			accuracy: accuracy,
			hits: hits,
			date: Date.now().toString()
			}, PlayState.getSongChanges());
			#end
			
			if (lastMenu == "Freeplay") FlxG.switchState(new FreeplayState());
			else if (lastMenu == "Gallery") FlxG.switchState(new ModState("PODGallery")); 
		}
	} 
}