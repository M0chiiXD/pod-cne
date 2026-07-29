import flixel.text.FlxText;

var titlecard;

var story:FunkinSprite;

function postCreate() {
	titlecard = new FunkinSprite();
    titlecard.loadSprite(Paths.image("game/titlecards/evil_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 0;
    titlecard.y = 100;
	titlecard.scale.set(1.1, 1.1);
	titlecard.addAnim("evil", "evil", 6, true);
    titlecard.cameras = [camHUD];
	insert(0, titlecard);
	titlecard.playAnim("evil");
	
	story = new FunkinSprite();
    story.loadSprite(Paths.image("stages/evil/evilStory"));
	story.screenCenter();
    story.alpha = 0;
	story.color = FlxColor.BLACK;
	story.addAnim("1", "1", 1, true);
	story.addAnim("2", "2", 1, true);
	story.addAnim("3", "3", 1, true);
	story.addAnim("4", "4", 1, true);
    story.cameras = [camHUD];
    add(story);
	
	strumLines.members[0].characters[0].visible = false;
	for (strum in strumLines.members[0]) {
		strum.color = FlxColor.RED;
	}
	
	bgevil.visible = false;
	bgEvil2.visible = false;
}

function onNoteCreation(e)
    if (e.strumLineID == 0)
        e.note.color = FlxColor.RED;

function stepHit(curStep:Int) {
    if (curStep == 60) {
		strumLines.members[0].characters[0].visible = true;
	} else if (curStep == 193) {
        FlxTween.tween(titlecard, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard.scale, {x: 1.3, y: 1.3}, 3, {ease: FlxEase.quadInOut});
		bgevil.visible = true;
	} else if (curStep == 220) {
		FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
    } else if (curStep == 1000) {
		bgEvil2.visible = true;
		bgevil.visible = false;
	} else if (curStep == 1512) {
		camGame.fade(FlxColor.BLACK, 0, false);
		FlxTween.tween(story, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
	} else if (curStep == 1536) {
		story.playAnim("1");
		FlxTween.color(story, 1,  FlxColor.BLACK, FlxColor.WHITE);
	} else if (curStep == 1552) {
		FlxTween.color(story, 1,  FlxColor.WHITE, FlxColor.BLACK);
	} else if (curStep == 1568) {
		story.playAnim("2");
		FlxTween.color(story, 1,  FlxColor.BLACK, FlxColor.WHITE);
	} else if (curStep == 1584) {
		FlxTween.color(story, 1,  FlxColor.WHITE, FlxColor.BLACK);
	} else if (curStep == 1600) {
		story.playAnim("3");
		FlxTween.color(story, 1,  FlxColor.BLACK, FlxColor.WHITE);
	} else if (curStep == 1616) {
		FlxTween.color(story, 1,  FlxColor.WHITE, FlxColor.BLACK);
	} else if (curStep == 1632) {
		story.playAnim("4");
		FlxTween.color(story, 1,  FlxColor.BLACK, FlxColor.WHITE);
	} else if (curStep == 1648) {
		FlxTween.color(story, 1,  FlxColor.WHITE, FlxColor.BLACK);
	} else if (curStep == 1664) {
		story.alpha = 0;
		bgevil.visible = false;
		bgEvil2.visible = false;
		camGame.fade(FlxColor.BLACK, 0, true);
	} else if (curStep == 1792) {
		bgEvil2.visible = true;
	}
}
