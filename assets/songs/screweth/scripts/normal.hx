var ironyhorse:FunkinSprite;

function create() {
	ironyhorse = new FunkinSprite(3000, 170, Paths.image("stages/screweth/ironyhorse"));
	ironyhorse.scale.set(1.5, 1.5);
	ironyhorse.addAnim("idle", "ironyhorse idle", 12, true);
	insert(members.indexOf(dad, bf), ironyhorse);
}

function stepHit(curStep:Int) {
    if (curStep == 128) {
		ironyhorse.playAnim("idle");
		ironyhorse.flipX = false;
		FlxTween.tween(ironyhorse, {x: -2000}, 9, {ease: FlxEase.linear});
	} else if (curStep == 666) {
		// scary number
		ironyhorse.playAnim("idle");
		ironyhorse.flipX = true;
		FlxTween.tween(ironyhorse, {x: 3000}, 0.54, {ease: FlxEase.linear});
	}
}