function create() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/greeeducation_titlecard"));
	titlecard.screenCenter();
    titlecard.y = -650;
	titlecard.scale.set(1, 1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function stepHit(curStep:Int) {
	if (curStep == 128) {
		FlxTween.tween(titlecard, { y: 160 }, 1.2, {ease: FlxEase.bounceOut});
	} else if (curStep == 178) {
		FlxTween.tween(titlecard, {alpha: 0,}, 2, {ease: FlxEase.quadInOut});
    }
}