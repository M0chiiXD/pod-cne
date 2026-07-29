import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;

var gameover = new FlxVideo();

static var burnedvar:String;

lossSFX = null;

var path = Paths.file("videos/deaths/" + PlayState.SONG.meta.name + ".mp4");

var burnedpath1 = Paths.file("videos/deaths/" + PlayState.SONG.meta.name + "-pre.mp4");
var burnedpath2 = Paths.file("videos/deaths/" + PlayState.SONG.meta.name + "-mid.mp4");

function create(e) {
	if (Assets.exists(path)) {
		if (gameover.load(Assets.getPath(path))) gameover.play();
		e.cancel();
		FlxG.addChildBelowMouse(gameover);
	} else if (PlayState.SONG.meta.name == "burned") {
		e.cancel();
		switch(burnedvar) {
			case "pre": 
				gameover.load(Assets.getPath(burnedpath1));
			case "mid": 
				gameover.load(Assets.getPath(burnedpath2));
		}
			gameover.play();
			FlxG.addChildBelowMouse(gameover);
	}
}

function update() {
	if (controls.BACK || controls.ACCEPT) {
		gameover.dispose();
		FlxG.removeChild(gameover);
		FlxG.switchState(new PlayState());
	} 
}