importScript("data/scripts/cinema");

var bluePencil:FunkinSprite;
var surkill:FunkinSprite;

function create() {
	bluePencil = new FunkinSprite(4300, 170, Paths.image("stages/thirty/bluepencil"));
	bluePencil.scale.set(1.1, 1.1);
	bluePencil.addAnim("idle", "bluepencil idle", 12, true);
	bluePencil.addAnim("walk", "bluepencil walk", 12, true);
	insert(members.indexOf(dad, bf), bluePencil);
	
	blueCam = new FlxSprite();
	blueCam.x = 3900;
	blueCam.y = 510;
	blueCam.makeGraphic(20, 20, FlxColor.BLACK);
	blueCam.alpha = 0;
	add(blueCam);
	
	surkill = new FunkinSprite(-50, 250, Paths.image("stages/thirty/surkill"));
	surkill.scale.set(0.7, 0.7);
	surkill.addAnim("idle", "surkill idle", 12, true);
	surkill.addAnim("dies", "surkill dies", 12, false);
	insert(members.indexOf(dad, bf), surkill);
	
	uhh = new FunkinSprite(-4000, 220, Paths.image("stages/thirty/uhh"));
	uhh.scale.set(0.62, 0.62);
	uhh.addAnim("idle", "uhh idle", 12, true);
	uhh.addAnim("scratch", "uhh headscratch", 12, true);
	uhh.addAnim("right", "uhh walkright", 3, true);
	uhh.addAnim("left", "uhh walkleft", 3, true);
	insert(members.indexOf(dad, bf), uhh);
	
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/TM_titlecard"));
	titlecard.screenCenter();
    titlecard.y = 100;
	titlecard.alpha = 0;
	titlecard.scale.set(1, 1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
}

var surBop:Bool = true;

function postCreate() {
	camGame.target = blueCam;
	if (surBop && curBeat % 1 == 0)
	{
		surkill.playAnim("idle");
	}
}

function onSongStart() {
	bluePencil.flipX = true;
	bluePencil.playAnim("walk");
	FlxTween.tween(titlecard.scale, {x: 1.2, y: 1.2}, 3, {ease: FlxEase.quadOut});
	FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
}

var camR:Float = 0;
var awesome:Bool = false;
function postUpdate(elapsed:Float) {		
	if (awesome) {
		if (curCameraTarget == 0) camR = 4.2;
		else if (curCameraTarget == 1) camR = -4.2;
		final shift = Math.abs(Math.sin(curBeatFloat * Math.PI));
		camGame.y = shift * -15;
		camHUD.y = shift * -10;
		bluePencil.y = lerp(bluePencil.y, 170, 0.08, true);
	} else {
		camR = 0;
	}
    camGame.angle = FlxMath.lerp(camGame.angle, camR, 0.5 * 15 * elapsed);
}

function beatHit() {
	if (awesome) {
		FlxTween.tween(bluePencil, {y: bluePencil.y - 100}, 0.08, {ease: FlxEase.quadOut});
	}
}

var chance:Int = 0;
function stepHit(curStep:Int) {
    if (curStep == 0) {
		FlxTween.tween(bluePencil, {x: 270}, 5.7, {ease: FlxEase.quadOut});
		FlxTween.tween(blueCam, {x: 970}, 4, {ease: FlxEase.quadInOut});
    } else if (curStep == 17) {
		FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadOut});
    } else if (curStep == 32) {
		bluePencil.playAnim("idle");
		bluePencil.flipX = false;
        camGame.target = camFollow;
		blueCam.destroy();
	} else if (curStep == 60) {
		// CHANCE EVENT!!!!
		chance = FlxG.random.int(0, 11);
		if (chance == 8) proGamerDies();
	} else if (curStep == 100) {
		bluePencil.x = 270;
    } else if (curStep == 380) {
		uhh.playAnim("right");
		FlxTween.tween(uhh, {x: -450}, 6, {ease: FlxEase.quadOut, onComplete: function() {
			uhh.playAnim("idle");
			}});
    } else if (curStep == 430) {
		uhh.playAnim("scratch");
    } else if (curStep == 440) {
		uhh.playAnim("idle");
    } else if (curStep == 446) {
		uhh.playAnim("left");
		FlxTween.tween(uhh, {x: -2000}, 6, {ease: FlxEase.quadOut, onComplete: function() {
			uhh.destroy();
			}});
    } else if (curStep == 512) {
		bluePencil.playAnim("walk");
		bluePencil.flipX = true;
        FlxTween.tween(bluePencil, {x: 3000}, 3, {ease: FlxEase.bounceIn});
	} else if (curStep == 610) {
		bluePencil.x = 3000;
    } else if (curStep == 640) {
		surBop = false;
		surkill.playAnim("dies");
		bluePencil.playAnim("idle");
		FlxTween.tween(bluePencil, {x: 200}, 1, {ease: FlxEase.bounceOut});
		bluePencil.flipX = false;
		FlxG.sound.play(Paths.sound("gun"), 0.6);
		awesome = true;		
    } else if (curStep == 768) {
		FlxG.sound.play(Paths.sound("gun"), 0.6);
		health = health - 0.5;
    } else if (curStep == 832) {
		FlxG.sound.play(Paths.sound("gun"), 0.6);
		health = health - 0.55;
    } else if (curStep == 864) {
		FlxG.sound.play(Paths.sound("gun"), 0.6);
		health = health - 0.6;
    } else if (curStep == 880) {
		FlxG.sound.play(Paths.sound("gun"), 0.6);
		health = health - 0.67; //676767676767-
    } else if (curStep == 896) {
		awesome = false;
		FlxTween.tween(bluePencil, {y: 170}, 3, {ease: FlxEase.bounceIn});
	}
}

function proGamerDies() {
	dad.playAnim("pullgun");
	dad.animation.onFinish.addOnce(function(anim:String) {
      if (anim == "pullgun") {
        dad.playAnim("shoot");
		FlxG.sound.play(Paths.sound("gun"), 0.6);
        gameOver();
      }
    });
}
