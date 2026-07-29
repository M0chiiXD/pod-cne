var titlecard;

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/therevenge_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 0;
    titlecard.y = 190;
	titlecard.scale.set(2.1, 1.5);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
	
	camGame.followLerp = 0.0025;
}

function stepHit(curStep:Int) {
    if (curStep == 224) {
    titlecard.alpha = 1;
	FlxTween.tween(titlecard, {alpha: 0}, 3, {ease: FlxEase.linear});
	FlxTween.tween(titlecard, {y: 220}, 0.1, {ease: FlxEase.linear, type: FlxTween.PINGPONG});
    } 
}