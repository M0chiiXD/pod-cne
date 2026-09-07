var titlecard;

var prevvy = stage.getSprite("bfdiaigimage");

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/devlog_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 0;
    titlecard.y = 150;
	titlecard.scale.set(1.1, 1,1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);

	prevvy.addAnim("buh", "bfdiaigimage idle0001", 1, true);
	prevvy.addAnim("idle", "bfdiaigimage idle", 2, true);
	prevvy.playAnim("idle");
	
	gf.y -= 1000;
	
	camHUD.alpha = 0;
	camGame.fade(FlxColor.BLACK, 0, false);
}

function onSongStart() {
	camGame.fade(FlxColor.BLACK, 0, true);
}

function beatHit() {
	FlxTween.cancelTweensOf(prevvy);

	prevvy.scale.set(.82, .83);
	FlxTween.tween(prevvy, {"scale.x": 0.8, "scale.y": 0.8}, 0.5, {ease: FlxEase.circOut});
}

function stepHit(curStep:Int) {
    if (curStep == 120) {
		FlxTween.tween(camHUD, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
	} else if (curStep == 128) {
        FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard.scale, {x: 1.3, y: 1.3}, 3, {ease: FlxEase.quadOut});
	} else if (curStep == 155) {
		FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
    } else if (curStep == 1536) {
		FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
    } else if (curStep == 1586) {
		FlxTween.tween(gf, {y: gf.y + 1000}, 1, {ease: FlxEase.bounceOut});
		prevvy.playAnim("buh");
    } else if (curStep == 1888) {
		camGame.fade(FlxColor.BLACK, 0, false);
		camHUD.alpha = 0.5;
		for (hud in [healthBar, healthBarBG, iconP1, iconP2, missesTxt]) hud.visible = false;
		strumLines.members[0].visible = false;
		strumLines.members[1].visible = false;
    } else if (curStep == 1936) {
		camHUD.fade(FlxColor.WHITE, 0.1, false);
    }
}
