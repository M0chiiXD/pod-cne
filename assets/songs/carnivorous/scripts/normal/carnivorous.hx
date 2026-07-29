import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil; //ill fix this later :b

importScript("data/scripts/burnedHUD");
importScript("data/scripts/cameraOffsetMove");

var burn = Paths.font("vcr.ttf");

function create(){	
	dadHealth = "Pencil";
	bfHealth = "Sapphire";
}

function onSongStart() {
	camHUD.fade(FlxColor.BLACK, 8, true);
}

function onDadHit(e){
	if (health > 0.2) health -= 0.01;
}