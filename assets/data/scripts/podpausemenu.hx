import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxAxes;

var pauseCam = new FlxCamera();

var bg:FlxSprite;
var hand:FlxSprite;

var texts:Array<FlxText> = [];

function create(event) {
	event.cancel();

	event.music = "skibidi-menu";

	cameras = [];

    pauseCam.bgColor = 0x88000000;
	pauseCam.alpha = 0;
	pauseCam.zoom = 1.5;
	
/*	coolPortrait = new FlxSprite(1500, 0);
	coolPortrait.scale.set(1.1, 1.1);
    coolPortrait.cameras = [pauseCam];
	coolPortrait.loadGraphic(Paths.image("menus/pause/portraits/" + PlayState.SONG.meta.name.toLowerCase()));
    add(coolPortrait);*/
	
	//right
	wrp1 = new FlxSprite(FlxG.width - 340, 480).loadGraphic(Paths.image("menus/pause/joem"));
    wrp1.camera = pauseCam;
	
	//left (i got things mixed sry chat)
	wrp2 = new FlxSprite(-60, 480).loadGraphic(Paths.image("menus/pause/joem"));
    wrp2.camera = pauseCam;
	
	//pos fixer for smooth shi
	wrp1.x += 300;
	wrp2.x -= 300;
	
	bg = new FlxSprite(0, 0).loadGraphic(Paths.image("menus/pause/bg"));
	bg.setGraphicSize(FlxG.width, FlxG.height);
	bg.updateHitbox();
    bg.camera = pauseCam;
	
	add(bg);
	add(wrp1);
	add(wrp2);
	
	// nvm
/*	songText = new FlxText();
	songText.text = CoolUtil.coolTextFile(Paths.getPath("songs/" + PlayState.instance.curSong + "/credits.txt")).join("\n");
	songText.scale.set(3, 3);
	songText.setPosition(13, 643);
	songText.updateHitbox();
	//confText(songText);
	add(songText);*/

	var i = 2;
	for(e in menuItems) {
		text = new FlxText(FlxG.width / 3.95, -33 + (i * 55) + 130, 0, e, 40, true);
		text.font = Paths.font("SourceCodePro.ttf");
		text.antialiasing = true;
		text.borderStyle = FlxTextBorderStyle.SHADOW;
		text.borderSize = 1;
		text.alpha = 0;
		text.updateHitbox();
		add(text);
		texts.push(text);
		i++;
	}

	hand = new FlxText(0, 0, 0, ">", 40, true);
	hand.font = Paths.font("SourceCodePro.ttf");
	hand.antialiasing = true;
	hand.borderStyle = FlxTextBorderStyle.SHADOW;
	hand.borderSize = 1;
	hand.updateHitbox();
	add(hand);
	
	FlxG.sound.play(Paths.sound('menu/scroll'));

	cameras = [pauseCam];
	
	FlxG.cameras.add(pauseCam, false);
	
	FlxTween.tween(pauseCam, {zoom: 1}, 0.5, {ease: FlxEase.cubeOut});
	
	FlxTween.tween(wrp1, {x: wrp1.x - 300}, 0.6, {ease: FlxEase.quadOut});
	FlxTween.tween(wrp2, {x: wrp2.x + 300}, 0.6, {ease: FlxEase.quadOut});
	FlxTween.tween(text, {alpha: 1}, 2, {ease: FlxEase.quadOut});
}

function postCreate() {
	FlxG.cameras.add(pauseCam, false);
}

var canDoShit = true;
var time:Float = 0;
function update(elapsed) {

	pauseCam.alpha = lerp(pauseCam.alpha, 1, 0.25);
	text.alpha = lerp(text.alpha, 1, 0.25);
	time += elapsed;

	var curText = texts[curSelected];
	hand.setPosition(curText.x - hand.width, curText.y + (text.height - hand.height));
	
	for (i in 0...menuItems.length) {
		texts[i].alpha = 0.6;
		texts[curSelected].alpha = 1;
	}
	
	if (!canDoShit) return;
	var oldSec = curSelected;

	changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

	if (oldSec != curSelected)
		FlxG.sound.play(Paths.sound('menu/scroll'));

	if (controls.ACCEPT) {
		FlxG.sound.play(Paths.sound('menu/cancel'));
		var option = menuItems[curSelected];
		if (option == "Resume") {
			canDoShit = false;
			for(t in texts) t.visible = false;
			hand.visible = false;
			FlxTween.tween(wrp1, {x: wrp1.x + 300}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(wrp2, {x: wrp2.x - 300}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(pauseCam, {zoom: 1.5}, 0.4, {ease: FlxEase.quadOut});
			FlxTween.tween(text, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(pauseCam, {alpha: 0}, 0.5, {ease: FlxEase.linear, onComplete: function() {
			selectOption();
			}});
		} else if (option == "Exit to menu") {
			canDoShit = false;
			for(t in texts) t.visible = false;
			hand.visible = false;
			FlxTween.tween(wrp1, {x: wrp1.x + 300}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(wrp2, {x: wrp2.x - 300}, 0.6, {ease: FlxEase.quadOut});
			FlxTween.tween(pauseCam, {zoom: 1.5}, 0.4, {ease: FlxEase.quadOut});
			FlxTween.tween(text, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
			FlxTween.tween(pauseCam, {alpha: 0}, 0.5, {ease: FlxEase.linear, onComplete: function() {
			switchMenu();
			}});
		} else {
			selectOption();
		}
	}
}

function changeSelection(change) {
	curSelected += change;

	if (curSelected < 0)
		curSelected = menuItems.length - 1;
	if (curSelected >= menuItems.length)
		curSelected = 0;
}

function switchMenu() {
	if (!PlayState.chartingMode){	
		if (lastMenu == "StoryMode") {
			FlxG.switchState(new StoryMenuState());
		} else if (lastMenu == "Freeplay") {
			FlxG.switchState(new FreeplayState());
		} else if (lastMenu == "Gallery") {
			FlxG.switchState(new ModState("PODGallery")); 
		}
	} else { 
		selectOption(); 
	}
}
