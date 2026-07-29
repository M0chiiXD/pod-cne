import funkin.game.PlayState.ComboRating;
import haxe.ds.ObjectMap;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxStringUtil;
import haxe.ds.ObjectMap;

var timer:FlxTimer = new FlxTimer();

var hits = 0;
var ratingSprX = 0;
var ratingSprY = 0;

var ratingSpr:FlxSprite;
var comboT:FlxText;

function postCreate(){
	comboGroup.visible = false;
	
	ratingSpr = new FunkinSprite();
	ratingSpr.y = 556;
	
	comboT = new FlxText(0, 0, 180, "67");
	comboT.setFormat(Paths.font("Packer-Regular.otf"), 55, FlxColor.WHITE, "center");
	comboT.scrollFactor.set(0, 0);
	comboT.borderStyle = FlxTextBorderStyle.OUTLINE;
	comboT.borderColor = FlxColor.BLACK;
	comboT.borderSize = 6;
	comboT.updateHitbox();
	
	comboT.alpha = ratingSpr.alpha = 0;
	comboT.cameras = ratingSpr.cameras = [camHUD];
	
	add(ratingSpr);
	add(comboT);
}

function onPlayerHit(e) {
	if (!e.note.isSustainNote) {
		updateRating(e.rating);
	}
}

function update(){
	ratingSpr.x = healthBar.x + healthBar.width / 1.3;
	comboT.setPosition(ratingSpr.x + 60, ratingSpr.y + 100);
	
	ratingSpr.scale.set(lerp(ratingSpr.scale.x, 0.5, 0.25), lerp(ratingSpr.scale.y, 0.5, 0.2));
	comboT.scale.set(lerp(comboT.scale.x, 0.9, 0.25), lerp(comboT.scale.y, 0.9, 0.2));
	var addScore:String = CoolUtil.addZeros(Std.string(combo), 3);
	comboT.text = addScore;
	comboT.alpha = ratingSpr.alpha;
}

function updateRating(h:String){
	FlxTween.cancelTweensOf(ratingSpr);
	
	for (ratings in [ratingSpr, comboT]) ratings.alpha = 1;
	ratingSpr.scale.set(0.55, 0.55);
	comboT.scale.set(0.95, 0.95);
	
	ratingSpr.loadGraphic(Paths.image("game/score/" + PlayState.difficulty + "/" + h));
	
	if (timer.active) timer.cancel();
    timer.start(0.25, () -> FlxTween.tween(ratingSpr, {alpha: 0}, 0.555, {ease: FlxEase.linear}) );
}