import openfl.display.BlendMode;

var auraTank:Character = null;
var auraPink:Character = null;

function postCreate() {
	auraTank = strumLines.members[1].characters[1];
	auraTank.x = 1500;
	
	auraPink = strumLines.members[0].characters[1];
	auraPink.x = -560;
	
	effect = new FlxSprite();
    effect.makeGraphic(FlxG.width, FlxG.height, FlxColor.PURPLE);
	effect.alpha = 0.5;
	effect.visible = false;
    effect.camera = camHUD;
	insert(0, effect);
	effect.blend = BlendMode.LIGHTEN;
	
	for (auras in [auraPink, auraTank]) {
		auras.scale.set(1.85, 1.85);
		auras.y -= 200;
		auras.visible = false;
		auras.blend = BlendMode.ADD;
		auras.color = FlxColor.MAGENTA;
		auras.camera = camHUD;
	}
}

var forceCam = false;
function onCameraMove(event:CamMoveEvent) event.cancelled = forceCam;

function beatHit() {
	if (curBeat % 2 == 0) {
		FlxTween.cancelTweensOf(effect);
		effect.alpha = 0.65;
		FlxTween.tween(effect, {alpha: 0.5}, 0.55, {ease: FlxEase.cubeOut});
	}
}

var dadCam = dad.getCameraPosition();
var bfCam = boyfriend.getCameraPosition();
function stepHit(curStep:Int) {
	switch (curStep) {
		case 1152:
			triggerCoolAuras(0);
		case 1216:
			triggerCoolAuras(1);
		case 1280:
			triggerCoolAuras(0);
		case 1344:
			triggerCoolAuras(1);
		case 1408:
			triggerCoolAuras(-1);
		case 1536: 
			camGame.visible = false;
	}
}

function triggerCoolAuras(strumLine:Int){	
	effect.visible = true;
	
	switch (strumLine) {
		case 0:
			forceCam = true;
			auraPink.x = -600;
			auraPink.visible = true;
			auraTank.visible = false;
			camFollow.setPosition(dadCam.x, dadCam.y);
			FlxTween.tween(auraPink, {x: 1400}, 5, {ease: FlxEase.linear});
		case 1:
			forceCam = true;
			auraTank.x = 1500;
			auraTank.visible = true;
			auraPink.visible = false;
			camFollow.setPosition(bfCam.x, bfCam.y);
			FlxTween.tween(auraTank, {x: -600}, 5, {ease: FlxEase.linear});
		case -1:
			forceCam = false;
			auraTank.visible = auraPink.visible = false;
			camGame.color = FlxColor.WHITE;
			effect.visible = false;
	}
}