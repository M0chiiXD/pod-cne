import flixel.text.FlxText;

var titlecard;

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/redandarrow_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 0;
    titlecard.y = 100;
	titlecard.scale.set(1.2, 1,2);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function stepHit(curStep:Int) {
    if (curStep == 160) {
        FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard.scale, {x: 1.5, y: 1.5}, 1, {ease: FlxEase.bounceOut});
	} else if (curStep == 185) {
		FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
    }
}
