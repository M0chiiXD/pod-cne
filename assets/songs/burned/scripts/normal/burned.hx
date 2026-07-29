import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil; //ill fix this later :b
import openfl.display.BlendMode;

var camStatic = FlxG.save.data.camStable;
static var burnedvar:String;

importScript("data/scripts/burnedHUD");
importScript("data/scripts/VideoHandler");
importScript("data/scripts/cameraOffsetMove");

var burn = Paths.font("vcr.ttf");

function create(){
	burnedvar = "pre";

	blur = new FunkinSprite(0, 0, Paths.image("stages/somni/static"));
	blur.scale.set(5, 5);
	blur.addAnim("idle", "static idle", 24, true);
    blur.alpha = 0;
    blur.cameras = [camHUD];
	insert(0, blur);
	
	miniscene = new FunkinSprite(0, 0, Paths.image("stages/burned/burned transition"));
	miniscene.setGraphicSize(FlxG.width, FlxG.height);
	miniscene.addAnim("1", "burned transition 1", 15, true);
	miniscene.addAnim("2", "burned transition 2", 15, true);
	miniscene.addAnim("3", "burned transition 3", 19, true);
	miniscene.cameras = [camHUD];
	insert(0, miniscene);
	
	miniscene.screenCenter();
	miniscene.visible = false;
	
	VideoHandler.load(["burnedcutscene1", "doorframe"]); //2nd vid is for testing
	
	dadHealth = "Pencil";
	bfHealth = "Azure";
}

function postCreate() blur.blend = BlendMode.ADD;

function onSongStart() //camHUD.fade(FlxColor.BLACK, 5, true);

var reveal:Bool = false;
function onDadHit(e) if (reveal) if (health > 0.2) health -= 0.02;

var angle:Bool = false;
var bouncy:Bool = false;
function postUpdate(elapsed:Float) {		
if (!camStatic) {
	if (angle) {
		if (curCameraTarget == 0) camR = -12;
		else if (curCameraTarget == 1) camR = 10;
		else if (curCameraTarget == -1) camR = 3;
	} else {
		camR = 0;
	}
	if (bouncy) {
		final shift = Math.abs(Math.sin(curBeatFloat * Math.PI));
		camGame.y = shift * -10;
		camHUD.y = shift * -10;
	}
    camGame.angle = FlxMath.lerp(camGame.angle, camR, 0.3 * 15 * elapsed);
}
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 192:
			reveal = true;
		case 1528:
			FlxTween.tween(blur, {alpha: 0.7},1, {ease: FlxEase.quadInOut});
			blur.playAnim("idle");
		case 1536:
			FlxTween.tween(blur, {alpha: 0}, 0.15, {ease: FlxEase.quadInOut, onComplete: (_) -> blur.destroy() });
		case 2014:
			VideoHandler.playNext();
		case 2144:
			camGame.visible = false;
		case 2180:
			VideoHandler.destroyCur();
			camHUD.fade(FlxColor.BLACK, 1.4, true);
			loadNextBG(1);
		case 2192:
			miniscene.visible = true;
			miniscene.scale.set(0.5, 0.5);
			miniscene.playAnim("1");
		case 2200:
			miniscene.visible = false;
		case 2208:
			miniscene.visible = true;
			miniscene.scale.set(0.7, 0.7);
			miniscene.playAnim("2");
		case 2216:
			miniscene.visible = false;
		case 2220:
			miniscene.visible = true;
			miniscene.playAnim("3");
			miniscene.scale.set(1, 1);
		case 2224:
			burnedvar = "mid";
			miniscene.destroy();
			camGame.visible = true;
			angle = true;
			bouncy = true;
		case 2448:
			loadNextBG(2);
			angle = false;
		case 2704:
			camGame.visible = false;
		case 2720:
			loadNextBG(3);
			camGame.visible = true;
		case 2848:
			VideoHandler.playNext();
		case 2880:
			VideoHandler.destroyCur();
			camGame.visible = camHUD.visible = false;
	}
}