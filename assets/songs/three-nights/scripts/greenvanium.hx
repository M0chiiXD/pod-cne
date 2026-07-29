var scratch = Paths.font("HelveticaNeueMedium.otf");

var pixel = Paths.font("scratch-pixel.ttf");

var healthcount:Float;

function create() {
	theCam = new FlxSprite();
	theCam.x = 670;
	theCam.y = 580;
	theCam.makeGraphic(20, 20, FlxColor.BLACK);
	theCam.alpha = 0;
	add(theCam);
	
/*	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/TM_titlecard"));
	titlecard.screenCenter();
    titlecard.y = 100;
	titlecard.alpha = 0;
	titlecard.scale.set(1, 1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);*/
	
	boyfriend.cameras = [camHUD];
	boyfriend.x = -600;
	boyfriend.y = 70;
	boyfriend.scale.set(0.6, 0.6);
	
	scoretxt = new FlxText();
	scoretxt.font = scratch;
	scoretxt.size = 50;
	scoretxt.x = 754;
	scoretxt.y = 1150;
	scoretxt.color = 0x6e6e6d;
	scoretxt.cameras = [camGame];
	add(scoretxt);
	
	misstxt = new FlxText();
	misstxt.font = scratch;
	misstxt.size = 24;
	misstxt.x = 907;
	misstxt.y = 680;
	misstxt.cameras = [camGame];
//	add(misstxt);

	healthtxt = new FlxText();
	healthtxt.color = FlxColor.WHITE;
	healthtxt.font = pixel;
	healthtxt.size = 100;
	healthtxt.x = -90;
	healthtxt.y = -100;
	healthtxt.letterSpacing = 20;
	healthtxt.cameras = [camGame];
	add(healthtxt);
	
	timetxt = new FlxText();
	timetxt.color = FlxColor.WHITE;
	timetxt.text = "12AM";
	timetxt.font = pixel;
	timetxt.size = 90;
	timetxt.x = -90;
	timetxt.y = 30;
	timetxt.cameras = [camGame];
	add(timetxt);
	
	// interactive stuff
	
	doorButtonLeft = new FunkinSprite();
	doorButtonLeft.loadSprite(Paths.image("stages/tnagp/BUTTON_DOOR_LEFT"));
	doorButtonLeft.addAnim("off", "red", 2, true);
	doorButtonLeft.addAnim("on", "green", 2, true);
	doorButtonLeft.scale.set(1.5, 1.5);
	doorButtonLeft.x = 115;
	doorButtonLeft.y = 560;
	doorButtonLeft.updateHitbox();
	doorButtonLeft.cameras = [camGame];
	insert(3, doorButtonLeft);
	
	doorButtonRight = new FunkinSprite();
	doorButtonRight.loadSprite(Paths.image("stages/tnagp/BUTTON_DOOR_RIGHT"));
	doorButtonRight.addAnim("off", "red", 2, true);
	doorButtonRight.addAnim("on", "green", 2, true);
	doorButtonRight.scale.set(1.5, 1.5);
	doorButtonRight.x = 1200;
	doorButtonRight.y = 560;
	doorButtonRight.updateHitbox();
	doorButtonRight.cameras = [camGame];
	insert(3, doorButtonRight);
	
	camButton = new FunkinSprite();
	camButton.loadSprite(Paths.image("stages/tnagp/camButton"));
	camButton.addAnim("open", "open", 2, true);
	camButton.addAnim("close", "close", 2, true);
	camButton.scale.set(1.6, 1.3);
	camButton.x = 0;
	camButton.y = 900;
	camButton.updateHitbox();
	camButton.cameras = [camGame];
	insert(10, camButton);
}

function postCreate() {
	camGame.target = theCam;
	
	for (h in [accuracyTxt, scoreTxt, missesTxt, healthBar, healthBarBG, iconP1, iconP2]){
		h.alpha = 0;
	}
}

function mouseOverlaps(sprite:FlxBasic, ?camera:FlxCamera) {
	var camToCheck:FlxCamera = camera ?? sprite.camera;
	var posthing:FlxPoint = FlxG.mouse.getWorldPosition(camToCheck);

	return posthing != null && FlxMath.inBounds(posthing.x, sprite.x, sprite.x + sprite.width) && FlxMath.inBounds(posthing.y, sprite.y, sprite.y + sprite.height);
}

function update(elapsed:Float){
	var camCheck:Bool = false;
	var doorLeft:Bool = false;
	var doorRight:Bool = false;

	FlxG.mouse.getWorldPosition();

		scoretxt.text = songScore;
//		misstxt.text = missesTxt.text;\
		healthtxt.text = Math.floor(health * 100 / maxHealth + 0.5) + "%";
		
		doorButtonLeft.playAnim("off");
		doorButtonRight.playAnim("off");
		
				if (mouseOverlaps(camButton, camGame)) {
					if (camCheck != true && FlxG.mouse.justPressed) {
						camButton.playAnim("open");
						camCheck = true;
						camButton.y = 926;
						trace("opencam");
					} else if ((camCheck) && FlxG.mouse.justPressed) {
						camButton.playAnim("close");
						camCheck = false;
						camButton.y = 900;
						trace("closecam");
					}
				}
				
				if (mouseOverlaps(doorButtonLeft, camGame)) {
					if (doorLeft != true  && FlxG.mouse.justPressed) {
						doorButtonLeft.playAnim("on");
						doorLeft = true;
						trace("opendoor");
					} else if ((doorLeft)  && FlxG.mouse.justPressed) {
						doorButtonLeft.playAnim("off");
						doorLeft = false;
						trace("closedoor");
					}
				}
}

function onSongStart() {
//	FlxTween.tween(titlecard.scale, {x: 1.2, y: 1.2}, 3, {ease: FlxEase.quadOut});
//	FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
}

function stepHit(curStep:Int) {
	if (curStep == 85) {
		FlxTween.tween(dad, { y: 224 }, 1.2, {ease: FlxEase.bounceOut});
	} else if (curStep == 128) {
		theCam.y = 500;
	}
}