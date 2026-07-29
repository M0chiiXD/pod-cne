import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxColor;

var camTitle:FlxCamera;
var titlecard:FlxSprite;

// MORE events will be coded laterrrrrrhhkskj

function create() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("stages/glassy/episode5.5"));
	titlecard.x = 275;
    titlecard.y = 0;
	titlecard.scale.set(0.35, 0.35);
	titlecard.updateHitbox();
    titlecard.cameras = [camHUD];
	
    darkener = new FlxSprite();
    darkener.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	darkener.screenCenter();
    darkener.cameras = [camHUD];
	
	add(darkener);
	add(titlecard);
	
	titlecard.scale.set(0.17, 0.17);
	titlecard.alpha = 0;
}

function postCreate() {
	camHUD.zoom = 2;
	
	for (i in 0...cpuStrums.members.length) {
		var glassyStrum = cpuStrums.members[i];
		glassyStrum.x -= 600;
	}
	for (i in 0...playerStrums.members.length) {
		var bfStrum = playerStrums.members[i];
		bfStrum.x -= 330;
	}
}

var bassDrop:Bool = false;
function update() {
	if (bassDrop) {
		camGame.width = 1280;
		camGame.height =  720;
		camGame.targetOffset.x = 0;
		camGame.x = 0;
	} else {
		camGame.width = 718;
		camGame.height =  718;
		camGame.targetOffset.x = 275;
		camGame.x = 275;
	}
}

function postUpdate(elapsed:Float) {		

}

function onSongStart() {
	FlxTween.tween(titlecard, {alpha: 1}, 3, {ease: FlxEase.cubeOut});
}

function stepHit(curStep:Int) {
    if (curStep == 64) {
		titlecard.visible = false;
		titlecard.exists = false;
		darkener.exists = false;
    } else if (curStep == 384) {
		bassDrop = true;
		for (i in 0...playerStrums.members.length) {
			var bfStrum = playerStrums.members[i];
            FlxTween.tween(bfStrum, {x: bfStrum.x + 330}, 1, {ease: FlxEase.cubeOut});
        }
		for (i in 0...cpuStrums.members.length) {
			var glassyStrum = cpuStrums.members[i];
            FlxTween.tween(glassyStrum, {x: glassyStrum.x + 600}, 1, {ease: FlxEase.cubeOut});
        }
    } else if (curStep == 1536) {
		bassDrop = false;
		for (i in 0...playerStrums.members.length) {
			var bfStrum = playerStrums.members[i];
            FlxTween.tween(bfStrum, {x: bfStrum.x - 330}, 1, {ease: FlxEase.cubeOut});
        }
		for (i in 0...cpuStrums.members.length) {
			var glassyStrum = cpuStrums.members[i];
            FlxTween.tween(glassyStrum, {x: glassyStrum.x - 600}, 1, {ease: FlxEase.cubeOut});
        }
    }
}

