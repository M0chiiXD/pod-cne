import flixel.text.FlxText;
import openfl.display.BlendMode;

importScript("data/scripts/cinema");

var titlecard;
var bump:Bool = false;
var cloudmove:Bool = false;

function postCreate() {
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/mirage_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 0;
    titlecard.y = -100;
	titlecard.scale.set(1, 1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);

	FlxTween.tween(gf, {y: gf.y - 15}, 1.4, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

	overlay = new FlxSprite();
    overlay.makeGraphic(1280, 768, FlxColor.MAGENTA);
    overlay.scrollFactor.set(0, 0);
	overlay.visible = false;
	overlay.screenCenter();
    overlay.cameras = [camHUD];
    insert(0, overlay);

	cloud1 = new FlxSprite();
    cloud1.loadGraphic(Paths.image("stages/mirage/cloud"));
    cloud1.scrollFactor.set(0.2, 0.2);
    cloud1.y = 100;
    cloud1.x = 2200;
	cloud1.scale.set(1, 1);
    cloud1.cameras = [camGame];
    insert(6, cloud1);

	cloud2 = new FlxSprite();
    cloud2.loadGraphic(Paths.image("stages/mirage/cloud"));
    cloud2.scrollFactor.set(0.55, 0.55);
    cloud2.y = 220;
    cloud2.x = 2200;
	cloud2.scale.set(1.1, 1.1);
    cloud2.cameras = [camGame];
    insert(6, cloud2);

	cloud3 = new FlxSprite();
    cloud3.loadGraphic(Paths.image("stages/mirage/cloud"));
    cloud3.scrollFactor.set(0.3, 0.3);
    cloud3.y = 150;
    cloud3.x = 2200;
	cloud3.scale.set(0.9, 1);
    cloud3.cameras = [camGame];
    insert(6, cloud3);

	cloud4 = new FlxSprite();
    cloud4.loadGraphic(Paths.image("stages/mirage/cloud"));
    cloud4.scrollFactor.set(0.6, 0.6);
    cloud4.y = 320;
    cloud4.x = 2200;
	cloud4.scale.set(1.2, 1.2);
    cloud4.cameras = [camGame];
    insert(6, cloud4);

	sun = new FlxSprite();
    sun.loadGraphic(Paths.image("stages/mirage/sun"));
    sun.scrollFactor.set(0.05, 0.05);
    sun.y = -600;
    sun.x = 500;
	sun.scale.set(1, 1);
    sun.cameras = [camGame];
    insert(6, sun);
	
	overlay.blend = BlendMode.DARKEN;
	camGame.fade(FlxColor.BLACK, 0, false);
}

function update(){
    if (cloudmove == true) {
        cloud1.x = cloud1.x - 0.04;
        cloud2.x = cloud2.x - 0.05;
        cloud3.x = cloud3.x - 0.03;
        cloud4.x = cloud4.x - 0.04;
    }
	if (curCameraTarget == 0){
		iconP2.setIcon("invisible person");
		//iconP2.iconColor = FlxColor.TRANSPARENT; - this does not work mochi
	} else if (curCameraTarget == 2){
		iconP2.setIcon("triange_icond");
		iconP2.iconColor = FlxColor.BLUE;
	} 
}

function beatHit() {
    if (bump == true) {
        sun.y = -80;

        FlxTween.tween(sun, {y: -100}, 0.4, {ease: FlxEase.cubeOut});
    }
}

function stepHit(curStep:Int) {
    if (curStep == 2) {
		camGame.fade(FlxColor.BLACK, 2, true);
	} else if (curStep == 32) {
        FlxTween.tween(cloud1, { x: 800}, 2, {ease: FlxEase.quintOut});
        FlxTween.tween(cloud2, { x: 1500}, 2, {ease: FlxEase.quintOut});
        FlxTween.tween(cloud3, { x: -400}, 2, {ease: FlxEase.quintOut});
        FlxTween.tween(cloud4, { x: 100}, 2, {ease: FlxEase.quintOut});
        FlxTween.tween(sun, { y: -100}, 2, {ease: FlxEase.quadOut});
        
	} else if (curStep == 34) {
        cloudmove = true;
	} else if (curStep == 160) {
		bump = true;

        FlxTween.tween(titlecard, {alpha: 1}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard.scale, {x: 1.5, y: 1.5}, 2, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard, { y: 100 }, 1.3, {ease: FlxEase.quadOut});
	} else if (curStep == 185) {
		FlxTween.tween(titlecard, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(titlecard, { y: 600 }, 0.9, {ease: FlxEase.quadIn});
	} else if (curStep == 288) {
		bump = false;
	} else if (curStep == 540) {
		overlay.visible = true;
	} else if (curStep == 544) {
		bump = true;
		overlay.visible = false;
	} else if (curStep == 800) {
		bump = false;
	} else if (curStep == 1192) {
        camGame.visible = false;
		camHUD.visible = false;
    }
}
