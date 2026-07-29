function create() {
	camGame.fade(FlxColor.BLACK, 0, false);
}

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/dash_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 1;
    titlecard.y = -760;
	titlecard.scale.set(1.1, 1,1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function onSongStart() {
	camGame.fade(FlxColor.BLACK, 8, true);
	FlxTween.tween(titlecard, {y: 150}, 3, {ease: FlxEase.quintOut, onComplete: (_) -> goAwayStupidTitlecard() });
}

function goAwayStupidTitlecard() {
		FlxTween.tween(titlecard, {alpha: 0}, 2, {ease: FlxEase.quintIn});
		FlxTween.tween(titlecard.scale, {x: 0}, 2, {ease: FlxEase.backIn});
		FlxTween.tween(titlecard.scale, {y: 0}, 2, {ease: FlxEase.backIn});
}