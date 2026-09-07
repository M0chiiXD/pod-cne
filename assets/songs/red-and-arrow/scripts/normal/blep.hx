import flixel.text.FlxText;
import openfl.display.BlendMode;

importScript("data/scripts/squareResize");

var titlecard;
var rgbg:FlxSprite;

function onPostStrumCreation(event){
	if (event.player == 0) {
		event.strum.setPosition(30, 790);
		event.strum.scrollFactor.set(1, 1);
		event.strum.noteAngle = 
			switch (event.strum.ID) {
				case 0: 90;
				case 1: 0;
				case 2: 180;
				case 3: 270;
			}
		event.strum.alpha = 0;
	}
}

function create() {
	VideoUtil.load(["redarrowbegin"], [], camHUD);
	camHUD.fade(FlxColor.BLACK, 0, false);
}

var limitAdder:Float = 1400;
function postCreate() {
	titlecard = new FlxSprite(0, 100).loadGraphic(Paths.image("game/titlecards/redandarrow_titlecard"));
	CoolUtil.cameraCenter(titlecard, camHUD, FlxAxes.X);
    titlecard.alpha = 0;
	titlecard.scale.set(1.2, 1,2);
    titlecard.camera = camHUD;
    insert(0, titlecard);
	
	// stupid
	if ((dadNotes = strumLines?.members[0]) != null) {
		dadNotes.notes.limit += limitAdder;
		dadNotes.camera = camGame;
		remove(strumLines);
		insert(members.indexOf(dad), strumLines);
	}
}

function onNoteCreation(note) 
	if (note.strumLineID == 0) {
		note.noteScale = 2.3;
		note.noteSprite = "game/notes/redArrowNotes";
}

function onDadHit() glowRedArrow();

function onSongStart() {
	new FlxTimer().start(0.3, function(tmr:FlxTimer){
		camHUD.fade(FlxColor.BLACK, 8, true);
		VideoUtil.playNext(0);
	});
}

//i hate rgb -megas
var hue:Float = 0;
var itsrgbTime:Bool = false;
// ill fix this laterrrgggghhhhhhh -myra
function update(elapsed:Float) {
    var bg = stage.getSprite("sky");
    if (itsrgbTime) {
        hue += elapsed * 500;
        if (hue >= 360)
            hue -= 360;
        bg.color = FlxColor.fromHSB(Std.int(hue), 1, 1);
    } else {
		bg.color = FlxColor.fromHSB(Std.int(hue), 0, 1);
    }
}

function stepHit(curStep:Int) {
	switch (curStep){
		case 192:
			VideoUtil.destroyCur();
			FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
			FlxTween.tween(titlecard.scale, {x: 1.5, y: 1.5}, 1, {ease: FlxEase.bounceOut});
		case 214:
			FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		case 768: itsrgbTime = true;
		case 1024: itsrgbTime = false;
		case 1786:
			for (i in 0...playerStrums.members.length) {
				var coolios = playerStrums.members[i];
				FlxTween.tween(coolios, {x: coolios.x - 260}, 1, {ease: FlxEase.circInOut});
			}
		case 2048:
			for (i in 0...playerStrums.members.length) {
				var coolios = playerStrums.members[i];
				FlxTween.tween(coolios, {x: coolios.x + 260}, 0.8, {ease: FlxEase.quadOut});
			}
    }
}

var thingy;
function glowRedArrow() {
	if (thingy != null) FlxTween.cancelTweensOf(thingy);
	thingy = FlxTween.num(3, 0.95, 0.15, {ease: FlxEase.cubeIn, onUpdate: (_) -> {
		dad.colorTransform.redMultiplier = thingy.value;
		dad.colorTransform.greenMultiplier = thingy.value;
		dad.colorTransform.blueMultiplier = thingy.value;
	}});
}
