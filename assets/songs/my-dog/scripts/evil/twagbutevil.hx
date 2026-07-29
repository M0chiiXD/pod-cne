import flixel.text.FlxText;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;

importScript("data/scripts/squareResize");

var blackOverlay;
var scratch = Paths.font("HelveticaNeueMedium.otf");
var scoreT:FlxText;
var guitar:FlxSprite;
var donutter:FlxTypedEmitter<FlxParticle>;
var donuts:Bool = false;

function create() {
	scoretxt = new FlxText();
	scoretxt.color = FlxColor.WHITE;
	scoretxt.font = scratch;
	scoretxt.size = 24;
	scoretxt.x = 12;
	scoretxt.y = 680;
	scoretxt.cameras = [camHUD];
	
	misstxt = new FlxText();
	misstxt.color = FlxColor.WHITE;
	misstxt.font = scratch;
	misstxt.size = 24;
	misstxt.x = camHUD.width / 2 - 12;
	misstxt.y = 680;
	misstxt.autoSize = false;
	misstxt.fieldWidth = 360;
	misstxt.alignment = "right";
	misstxt.cameras = [camHUD];
	
	blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1024, 768, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    insert(0, blackOverlay);
}

function postCreate() {
	missesTxt.visible = false;
	
	remove(iconP1);
	remove(iconP2);
	add(iconP1);
	add(iconP2);
	add(scoretxt);
	add(misstxt);
	
	doIconBop = false;
	
	switchChar(1);
	blackOverlay.alpha = 0.5;
}

function update(elapsed:Float){
		scoretxt.text = "Score: " + songScore;
		misstxt.text = "Misses: " + misses;
}

function onNoteCreation(note) note.noteSprite = "game/notes/averyNotes";

function onStrumCreation(note) note.sprite = "game/notes/averyNotes";

function onNoteHit(e) e.showSplash = false;

function switchChar(struh:Int) {
	if (struh == 0){
		iconP2.setIcon("avery");
	} else if (struh == 1){
		iconP2.setIcon("averyevil");
	}
}