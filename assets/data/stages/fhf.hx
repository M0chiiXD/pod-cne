var froggy:FunkinSprite;
var furry:FunkinSprite;

var drop:Bool = false;
var frogger:Bool;

function create() {
	froggy = new FunkinSprite(260, 400, Paths.image("stages/glassy/froggybg"));
	froggy.scale.set(0.63, 0.63);
	froggy.addAnim("idle1", "froggybg idleleft", 9, false);
	froggy.addAnim("idle2", "froggybg idleright", 9, false);
	froggy.addAnim("cheer", "froggybg happy", 12, true);
	insert(members.indexOf(dad, bf), froggy);
	
	balloony = new FunkinSprite(1200, 300, Paths.image("stages/glassy/balloonybg"));
	balloony.scale.set(0.83, 0.83);
	balloony.addAnim("idle", "balloonybg idle", 8, true);
	balloony.addAnim("cheer", "balloonybg happy", 10, false);
	insert(members.indexOf(dad, bf), balloony);

	FlxTween.tween(balloony, {y: balloony.y - 20}, 1, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
}

function beatHit() {
	if (!drop) {
		if (frogger) {
			froggy.playAnim("idle1");
			frogger = !frogger;
		} else {
			froggy.playAnim("idle2");
			frogger = !frogger;
		}
		balloony.playAnim("idle");
	} else {
		froggy.playAnim("cheer");
		balloony.playAnim("cheer");
	}
}

function stepHit() {
	if (curStep == 1280) {
		drop = true;
	} else if (curStep == 1536) {
		drop = false;
	}
}