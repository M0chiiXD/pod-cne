import flixel.FlxCamera;

importScript("data/scripts/cinema");

var hyper = new FlxCamera();

function create() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/whosthat_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 1;
    titlecard.y = -650;
	titlecard.x = 320;
	titlecard.scale.set(1.1, 1,1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
	
	hypercam = new FlxSprite(); // can you guys fix this for me thanks // okay sure buddy - acid axi // thanks acid axi - mustard mochi
    hypercam.loadGraphic(Paths.image("stages/connormaxxing/hypercam"));
	hypercam.x = -470;
    hypercam.y = -40;
	hypercam.scale.set(0.3, 0.3);
	hypercam.alpha = 1;
    hypercam.cameras = [hyper];
    add(hypercam);
	
	hyper.bgColor = 0x00000000;
	hyper.alpha = 1;
	FlxG.cameras.add(hyper, false);
}

function stepHit(curStep:Int) {
    if (curStep == 448) {
		strumLines.members[0].characters[0].visible = strumLines.members[0].visible = false;
    } else if (curStep == 576) {
		strumLines.members[0].visible = strumLines.members[0].characters[0].visible = true;
	} else if (curStep == 128) {
		FlxTween.tween(titlecard, {x: 670, y: 160}, 1, {ease: FlxEase.quartOut});
	} else if (curStep == 180) {
		FlxTween.tween(titlecard, {x: 1300, y: 160}, 1.2, {ease: FlxEase.backIn});
	}
}