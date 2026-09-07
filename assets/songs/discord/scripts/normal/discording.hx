importScript("data/scripts/squareResize");

function create() {
	VideoUtil.load(["trans"], [], camHUD);
}

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/discord_titlecard"));
	titlecard.x = 220;
    titlecard.y = -600;
	titlecard.scale.set(1, 1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

function stepHit(curStep:Int) {
	if (curStep == 55) {
		VideoUtil.playNext();
	} else if (curStep == 62) {
		FlxTween.tween(titlecard, { y: 100 }, 1.2, {ease: FlxEase.bounceOut});
	} else if (curStep == 100) {
		FlxTween.tween(titlecard, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
    } else if (curStep == 728) {
		FlxTween.tween(dad, {"scale.x": 2, "scale.y": 0.2}, 0.67, {ease: FlxEase.bounceOut});
		FlxTween.tween(camHUD, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
    } else if (curStep == 733) {
		FlxTween.tween(dad.scale, {x: 1}, 0.5, {ease: FlxEase.bounceIn});
		FlxTween.tween(dad.scale, {y: 1}, 0.5, {ease: FlxEase.bounceOut});
    } else if (curStep == 737) {
		FlxTween.tween(camHUD, {alpha: 1}, 0.55, {ease: FlxEase.quadIn});
    } else if (curStep == 753) {
		FlxTween.tween(dad, {x: -120}, 0.2, {ease: FlxEase.quadOut});		
    } else if (curStep == 758) {
		FlxTween.tween(dad, {x: -78}, 0.2, {ease: FlxEase.quadOut});		
    } else if (curStep == 761) {
		FlxTween.tween(dad, {x: -120}, 0.2, {ease: FlxEase.quadOut});	
    } else if (curStep == 765) {
		FlxTween.tween(dad, {x: -78}, 0.2, {ease: FlxEase.quadOut});	
    } else if (curStep == 769) {
		FlxTween.tween(dad, {x: 2500}, 1.2, {ease: FlxEase.linear});	
		FlxTween.angle(dad, 0, 1440, 1, {ease: FlxEase.quadIn});
		for (i in 0...cpuStrums.members.length) {
			var GPStrum = cpuStrums.members[i];
            FlxTween.tween(GPStrum, {x: GPStrum.x + 1000}, 1.2, {ease: FlxEase.linear});
        }
	} else if (curStep == 810) {
		for (i in 0...cpuStrums.members.length) {
			var GPStrum = cpuStrums.members[i];
			GPStrum.x -= 1000;
			GPStrum.y = GPStrum.y - 500;
            FlxTween.tween(GPStrum, {y: GPStrum.y + 500}, 0.5, {ease: FlxEase.quartOut});
        }
    }	else if (curStep == 832) {
		dad.x = -110;
		dad.angle = 0;
    } else if (curStep == 1472) {
		FlxTween.angle(dad, 0, 1440, 1.4, {ease: FlxEase.quintIn});
	}
}
