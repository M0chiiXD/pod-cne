import flixel.text.FlxText;
var scratch = Paths.font("HelveticaNeueMedium.otf");

var evil:Bool = false;

function create() {
	tipstxt = new FlxText();
	tipstxt.color = FlxColor.BLACK;
	tipstxt.font = scratch;
	tipstxt.size = 16;
	tipstxt.x = 12;
	tipstxt.y = 680;
	tipstxt.cameras = [camHUD];
	
	tipstxt.text = "a and d to move and press space to jump!!!\ncollect all the coins for a extra aura!";
}

function postCreate() {
	add(tipstxt);
}

function beatHit() {
	if (evil) {
    	health = lerp(health, health - 0.06, 1);
	}
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 501: 
			camGame.visible = false;
		case 520:
			evilTime(true);
		case 544:
			camGame.visible = true;
		case 672:
			evil = true;
		case 1024:
			evil = false;
			evilTime(false);
	}
}

function evilTime(isittime:Bool) {
	var garb1 = stage.getSprite("garb1");
	var time = isittime;
	if (time) {
		garb1.visible = false;
	} else if (!time) {
		garb1.visible = true;
	}
}

