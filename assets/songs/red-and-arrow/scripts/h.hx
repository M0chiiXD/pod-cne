import StringTools;
import openfl.display.StageQuality;

function create(){
	// i dont know if this does anything but blehhhhh -myra
	FlxG.stage.quality = -1;
	trace(FlxG.stage.quality);
}

var blackOverlay;

function postCreate(){	
    camHUD.width = camGame.width = 960;
    camHUD.height = camGame.height = 720;
	
	healthBar.visible = true;
    healthBarBG.antialiasing = true;
    doIconBop = true;
	
	corner = new FlxSprite(-90, FlxG.height - 80).makeGraphic(600, 300, FlxColor.BLACK);
	corner.angle = 15;
	corner.camera = camHUD;
	insert(members.indexOf(healthBar), corner);
}

var corner:FlxSprite;
function postUpdate(){
    missesTxt.setPosition(500, FlxG.height - 35);
	iconP2.visible = iconP1.visible = healthBarBG.visible = false;
	healthBar.scale.set(0.685, 1.5);
	healthBar.angle = 15;
	healthBar.updateHitbox();
	healthBar.setPosition(5, FlxG.height - 78);
}