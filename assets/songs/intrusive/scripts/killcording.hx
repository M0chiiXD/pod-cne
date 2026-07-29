importScript("data/scripts/squareResize");

var camStatic = FlxG.save.data.camStable;

var camR:Float = 0;
var angle:Bool = false;
var coolness = false;
var angleBop:Bool = false;
var titlecard;

function create() {
	camGame.fade(FlxColor.BLACK, 0, false);
}

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/intrusive_titlecard"));
    titlecard.alpha = 0;
    titlecard.x = 220;
    titlecard.y = 150;
	titlecard.scale.set(1.1, 1,1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function onSongStart() {
	camGame.fade(FlxColor.BLACK, 1.5, true);
}

function postUpdate(elapsed:Float) {		
if (!camStatic) {
	if (angle) {
		if (curCameraTarget == 0) camR = -4;
		else if (curCameraTarget == 1) camR = 4;
	} else {
		camR = 0;
	}
    camGame.angle = FlxMath.lerp(camGame.angle, camR, 0.5 * 15 * elapsed);
}
}

function beatHit() {
if (!camStatic) {
	if (coolness && !angle) {
		if (angleBop){
			camGame.angle = -4;
			angleBop = !angleBop;
		} else {
			camGame.angle = 4;
			angleBop = !angleBop;
		}
	}
}
}

function stepHit(curStep:Int) {
	if (curStep == 0) {
        FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard.scale, {x: 1.3, y: 1.3}, 3, {ease: FlxEase.quadOut});
	} else if (curStep == 20) {
		FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
    }
    if (curStep == 128) {
		angle = true;
    } else if (curStep == 258) {
		angle = false;
		coolness = true;
    } else if (curStep == 512) {
		coolness = false;
    } else if (curStep == 783) {
		angle = true;
		coolness = false;
    } else if (curStep == 911) {
		angle = false;
		coolness = true;
    } else if (curStep == 1167) {
		angle = false;
		coolness = false;
    }
}
