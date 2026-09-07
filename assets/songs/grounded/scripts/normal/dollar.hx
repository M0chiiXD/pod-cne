var border:FlxSprite;
var titlecard;

function create() {
	border = new FlxSprite();
    border.loadGraphic(Paths.image("stages/grounded/ground me harder"));
	border.scrollFactor.set(0, 0);
	border.scale.set(1.9, 1.4);
	border.updateHitbox();
	border.x = -300;
    border.y = -140;
    border.cameras = [camGame];
	add(border);
}

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/grounded_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 1;
    titlecard.y = 132;
    titlecard.x = 300;
	titlecard.scale.set(2.9, 1.8);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function stepHit(curStep:Int) {
    if (curStep == 288) {
		FlxTween.tween(border, {y: 1500}, 1.3, {ease: FlxEase.circIn});
		FlxTween.tween(border, {alpha: 0}, 1.2, {ease: FlxEase.circIn});
    } else if (curStep == 396) {
		FlxTween.tween(border, {y: -140}, 1.5, {ease: FlxEase.backInOut});
		FlxTween.tween(border, {alpha: 1}, 1.2, {ease: FlxEase.backInOut});
    } else if (curStep == 672) {
		FlxTween.tween(border, {y: 1500}, 1.3, {ease: FlxEase.circIn});
		FlxTween.tween(border, {alpha: 0}, 1.2, {ease: FlxEase.circIn});
    } else if (curStep == 16) {
		FlxTween.tween(titlecard, {alpha: 0}, 1.2, {ease: FlxEase.circOut});
    }
}

