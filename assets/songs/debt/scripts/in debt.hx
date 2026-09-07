function create() {
	VideoUtil.load(["debtintro"], [], camHUD);
}

function postCreate() {
	titlecard = new FlxSprite(220, -270).loadGraphic(Paths.image("game/titlecards/debt_titlecard"));
	titlecard.scale.set(0.9, 0.9);
	titlecard.alpha = 0;
    titlecard.cameras = [camHUD];
    insert(0, titlecard);

	apple = new FunkinSprite(1500, 300, Paths.image("stages/idk/apple"));
	apple.scale.set(0.9, 0.9);
	apple.addAnim("walk", "apple walk", 20, true);
	insert(members.indexOf(dad, bf), apple);

	redButton = new FunkinSprite(1300, 320, Paths.image("stages/idk/redbutton"));
	redButton.scale.set(0.9, 0.9);
	insert(members.indexOf(dad, bf), redButton);

	apple.playAnim("walk");
	
	camHUD.fade(FlxColor.BLACK, 0, false);
	camGame.fade(FlxColor.BLACK, 0, false);
}

function beatHit() {
    if (curBeat % 2 == 0) FlxTween.tween(redButton, {y: 150, "scale.y": 1.1, "scale.x": 0.9}, 0.6, {ease: FlxEase.cubeOut});
    else if (curBeat % 1 == 0) FlxTween.tween(redButton, {y: 320, "scale.y": 1, "scale.x": 1.1}, 0.5, {ease: FlxEase.quintIn});
}


function onSongStart(){
	camHUD.fade(FlxColor.BLACK, 0, true);
	VideoUtil.playNext();
}


function stepHit(curStep:Int) {
	if (curStep == 64) {
		camGame.fade(FlxColor.BLACK, 0, true);
		FlxTween.tween(titlecard, { y: 125 }, 1.2, {ease: FlxEase.quintOut});
		FlxTween.tween(titlecard, {alpha: 1}, 1.2, {ease: FlxEase.quintOut});
		FlxTween.tween(titlecard, {"scale.x": 1.1, "scale.y": 1.1}, 1.2, {ease: FlxEase.quintOut});
	} else if (curStep == 78) {
		FlxTween.tween(titlecard, {alpha: 0}, 2, {ease: FlxEase.quintOut});
		FlxTween.tween(titlecard, { y: 600 }, 2, {ease: FlxEase.quintOut});
		FlxTween.tween(titlecard, {"scale.x": 0.9, "scale.y": 0.9}, 2, {ease: FlxEase.quintOut});
	} else if (curStep == 256) {
		FlxTween.tween(apple, { x: -1000 }, 1.4, {ease: FlxEase.linear});
	} else if (curStep == 528) {
		happi = true;
	}
}
