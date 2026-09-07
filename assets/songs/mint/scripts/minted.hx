import openfl.display.BlendMode;

var startPos:Array<Float> = [];
var waveTime:Float = 0;
var waveStrength:Float = 0;
var waveSpeed:Float = 2.0;

function create(){
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/mint_titlecard"));
	titlecard.screenCenter();
    titlecard.y = -600;
	titlecard.scale.set(1, 1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
	
	black = new FlxSprite();
    black.makeGraphic(2000, 2000, FlxColor.BLACK);
    black.scrollFactor.set(0, 0);
	black.scale.set(10, 10);
    black.alpha = 0;
    black.cameras = [camGame];
	add(black);
}

function postCreate(){
	FlxG.bitmap.add(Paths.image("stages/myko/spotlight"));
	
	spotlight1 = new FlxSprite(1290, -500);
    add(spotlight1);
	
	spotlight2 = new FlxSprite(150, -500);
    add(spotlight2);
	
	for (spotlights in [spotlight1, spotlight2]) {
		spotlights.loadGraphic(Paths.image("stages/myko/spotlight"));
		spotlights.scale.set(1.5, 2);
		spotlights.alpha = 0;
		spotlights.blend = BlendMode.ADD;
		spotlights.updateHitbox();
		spotlights.cameras = [camGame];
	}
	
	for (strum in strumLines) startPos.push(strum.members[0].y);
	
	camGame.fade(FlxColor.BLACK, 0, false);
}

function onSongStart() {
	camGame.fade(FlxColor.BLACK, 6.5, true);
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 126:
			bloomBop = true;
			FlxTween.tween(titlecard.scale, {x: 1.2, y: 1.2}, 0.7, {ease: FlxEase.quadInOut});
			FlxTween.tween(titlecard, { y: 100 }, 1, {ease: FlxEase.quartOut});
		case 136:
			titlecard.scale.set(1.3, 1.3);
			FlxTween.tween(titlecard, {"scale.x": 1.2, "scale.y": 1.2}, 0.5, {ease: FlxEase.circOut});
		case 145:
			FlxTween.tween(titlecard, {y: 700}, 1, {ease: FlxEase.quadIn});
			FlxTween.tween(titlecard.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quadInOut});
		case 256: bloomBop = false;
		case 320: bloomBop = true;
		case 368: bloomBop = false;
		case 384: bloomBop = true;
		case 640: 
			bloomFX = [18, 0.68, 0.05, 4];
		case 768: bloomBop = false;
		case 900:
			FlxTween.tween(black, {alpha: 0.5}, 1, {ease: FlxEase.quadIn});
			FlxTween.tween(spotlight1, {alpha: 1}, 2, {ease: FlxEase.quadIn});
		case 956:
			FlxTween.tween(spotlight2, {alpha: 1}, 2, {ease: FlxEase.quadIn});
		case 992: 
			bloomBop = true;
			bloomFX = [18, 0.85, 0.085, 1];
		case 1008: bloomBop = false;
		case 1024:
			for (c in [spotlight1, spotlight2, black]) FlxTween.tween(c, {alpha: 0}, 0.5, {ease: FlxEase.quadIn});
			minty = true;
			waveSpeed = 2.0;
			bloomBop = true;
		case 1280: minty = false;
		case 1400: bloomBop = false;
		case 1408: 
			bloomBop = true;
			bloomFX = [18, 0.885, 0.0765, 1];
		case 1536: bloomBop = false;
    }
}

function update(elapsed:Float) {
    waveTime += elapsed;

    var fadeSpeed = 2.5;
    if (minty) {
        waveStrength = Math.min(0.5, waveStrength + elapsed * fadeSpeed);
    } else {
        waveStrength = Math.max(0, waveStrength - elapsed * fadeSpeed);
    }

    for (a in 0...strumLines.length) {
        for (b in 0...strumLines.members[a].length) {
            var note = strumLines.members[a].members[b];
            var baseY = startPos[a];
            var offset = Math.sin(waveTime * waveSpeed + b) * 20 * waveStrength;
            note.y = baseY + offset;
        }
    }
}
