importScript("data/scripts/VideoHandler");

var titlecard;

function create() {	
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/doorframe_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 1;
    titlecard.y = 150;
	titlecard.x = 300;
	titlecard.scale.set(1.1, 1,1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
	
	VideoHandler.load(["doorframe"]);
	
	camGame.fade(FlxColor.BLACK, 0, false);
}

function postCreate() {
	camHUD.alpha = 0;
	VideoHandler.playNext();
}

function stepHit(curStep:Int) {
	if (curStep == 128) {
		camGame.fade(FlxColor.BLACK, 0, true);
		camHUD.alpha = 1;
	} else if (curStep == 129) {
		FlxTween.tween(titlecard.scale, { x: 1.2, y: 1.2 }, 3, {ease: FlxEase.quadOut});
	} else if (curStep == 164) {
		FlxTween.tween(titlecard, {alpha: 0,}, 2.3, {ease: FlxEase.quadInOut});
    }
}