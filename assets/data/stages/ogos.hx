var trafficcone;
var compass;
var chocolateball;
var sandwichyw;
var burger;
var scribbley;
var geary;

function postCreate() {
	geary.addAnim("right", "geary right", 6, true);
	geary.addAnim("left", "geary left", 6, true);

	kelp.addAnim("idle", "kelp idle", 12, false);
	
	trafficcone.addAnim("idle", "trafficcone idle", 12, false);
	trafficcone.addAnim("intro", "trafficcone intro", 14, false);
	trafficcone.addAnim("scared", "trafficcone scared", 12, false);
	trafficcone.visible = false;
	trafficconeIdle = false;


	five.addAnim("idle", "five idle", 12, false);
	five.addAnim("up", "five up", 3, false);

	peachy.addAnim("idle", "peachy idle", 12, false);
	peachy.addAnim("happy", "peachy happy", 12, false);

	lemon.addAnim("idle", "lemon idle", 12, false);
	lemon.addAnim("happy", "lemon happy", 12, false);

	compass.addAnim("idle", "compass idle", 12, true);
	compass.addAnim("walk", "compass walk", 12, true);
	compass.addAnim("stop", "compass stop", 12, false);
	compass.addAnim("happy", "compass happy", 6, true);
	compass.visible = false;
	compassidle = false;
	FlxTween.tween(compass, {x: -1200}, 1.9, {ease: FlxEase.linear});

	lightpole.addAnim("idle", "lightpole idle", 12, false);
	lightpole.addAnim("slip", "lightpole slip", 12, false);
	lightpoleIdle = true;

	chocolateball.addAnim("idle", "chocolateball idle", 12, true);
	chocolateball.addAnim("disgust", "chocolateball disgust", 4, false);
	chocolateball.addAnim("walk", "chocolateball walk", 12, true);
	chocolateball.visible = false;
	FlxTween.tween(chocolateball, {x: 1700}, 0.01, {ease: FlxEase.linear});

	scribbley.addAnim("walk", "scribbley walk", 6, true);
	scribbley.addAnim("idle", "scribbley idle", 6, true);
	scribbley.visible = false;

	saltshaker.addAnim("walk", "saltshaker walk", 6, true);
	saltshaker.addAnim("idle", "saltshaker idle", 6, true);
	saltshaker.visible = false;

	camTop = new FlxCamera();
    camTop.bgColor = FlxColor.TRANSPARENT;
    camTop.visible = true;
	FlxG.cameras.add(camTop, false);

	sandwichyw.addAnim("skip", "sandwichyw skip", 6, true);
	burger.addAnim("walk", "burger walk", 6, true);
	sandwichyw.cameras = [camTop];
	burger.cameras = [camTop];
}


function beatHit() {
	kelp.playAnim("idle");

	if (compassidle == true) {
		if (curStep > 1472) {
			compass.playAnim("happy");
	}
		else if (curStep < 1472) {
			compass.playAnim("idle");	}
	}

	if (curStep > 1472) {
		lemon.playAnim("happy");
		peachy.playAnim("happy");
	}

	else if (curStep < 1472) {
		lemon.playAnim("idle");
		peachy.playAnim("idle");
	}

	if (lightpoleIdle == true) lightpole.playAnim("idle");
    
	if (trafficconeIdle == true) trafficcone.playAnim("idle");
	else if (trafficconeIdle == false) trafficcone.playAnim("scared");
	
	if (curCameraTarget == 0) geary.playAnim("left");
	else if (curCameraTarget == 1) geary.playAnim("right");
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 129: 
			trafficcone.visible = true;
			trafficcone.playAnim("intro");
		case 130:
			trafficconeIdle = true;
		case 256:
			chocolateball.visible = true;
			chocolateball.playAnim("walk");
			FlxTween.tween(chocolateball, {x: 454}, 3, {ease: FlxEase.linear});
		case 288:
			chocolateball.playAnim("idle");
		case 320:
			scribbley.visible = true;
			scribbley.playAnim("walk");
			FlxTween.tween(scribbley, {x: 1144}, 3, {ease: FlxEase.linear});
		case 352:
			scribbley.playAnim("idle");
		case 653:
			compass.playAnim("walk");
			compass.visible = true;
			FlxTween.tween(compass, {x: -546}, 1.4, {ease: FlxEase.linear});
		case 668:
			compass.playAnim("stop");
			FlxTween.tween(compass, {x: -596}, 0.3, {ease: FlxEase.circOut});
		case 672:
			compass.flipX = true;
			compass.playAnim("idle");
			compassidle = true;
		case 896:
			sandwichyw.playAnim("skip");
			burger.playAnim("walk");

			FlxTween.tween(burger, {x: 2000}, 12, {ease: FlxEase.linear});
			FlxTween.tween(sandwichyw, {x: 1800}, 12, {ease: FlxEase.linear});
		case 1040:
			saltshaker.visible = true;
			saltshaker.playAnim("walk");
			FlxTween.tween(saltshaker, {x: -401}, 3, {ease: FlxEase.linear});
		case 1072:
			saltshaker.playAnim("idle");
		case 1090:
			lightpoleIdle = false;
			lightpole.playAnim("slip");
		case 1472:
			five.playAnim("up");
			FlxTween.tween(five, {y: -1200}, 12, {ease: FlxEase.linear});	
			trafficconeIdle = false;
		case 1480:
			chocolateball.playAnim("disgust");
		case 1504:
			chocolateball.playAnim("idle");
		case 1696:
			chocolateball.playAnim("walk");
			FlxTween.tween(chocolateball, {x: -2000}, 1.5, {ease: FlxEase.elasticInOut});
	}
}
