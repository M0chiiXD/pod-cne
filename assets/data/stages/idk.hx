import flixel.FlxObject;
import flixel.FlxCamera;

public var leftCamera:FlxCamera;
public var rightCamera:FlxCamera;

importScript("data/scripts/squareResize");

var camFollow_left:FlxObject = new FlxObject();
var camFollow_right:FlxObject = new FlxObject();
static var happi:Bool = false;

function postCreate() {
	gf.visible = false;
	
	sword.addAnim("idle", "sword idle", 12, false);
	greenflag.addAnim("idle", "greenflag idle", 12, false);
	rocke.addAnim("bored", "rocke bored", 12, false);
	rocke.addAnim("amused", "rocke amused", 12, false);

	leftCamera = new FlxCamera(0,0, 1000 / 2, 720);
	rightCamera = new FlxCamera(0,0, 1000 / 2, 720);
    
	leftCamera.x = 140;
	rightCamera.x = 140 + leftCamera.width;
	
	leftCamera.y = 720;
	rightCamera.y = -720;

    leftCamera.bgColor = rightCamera.bgColor = 0;
	leftCamera.visible = rightCamera.visible = false;
    
    FlxG.cameras.remove(camHUD, false);
	FlxG.cameras.add(leftCamera, false);
	FlxG.cameras.add(rightCamera, false);
	FlxG.cameras.add(camHUD, false);
	
	var point = dad.getCameraPosition();
    camFollow_left.setPosition(point.x - 150, point.y + 28);
    leftCamera.follow(camFollow_left, 0.04);
	
	point = boyfriend.getCameraPosition();
    camFollow_right.setPosition(point.x + 120, point.y + 28);
    rightCamera.follow(camFollow_right, 0.04);
	
	cameras = [camGame, leftCamera, rightCamera];
	happi = false;
}

function beatHit() {
	sword.playAnim("idle");	
	greenflag.playAnim("idle");

    if (happi) rocke.playAnim("amused");
    else rocke.playAnim("bored");
}

function stepHit(curStep:Int) {
    if (curStep == 776) {
		leftCamera.visible = rightCamera.visible = true;
		FlxTween.tween(rightCamera, {y: 0}, 1, {ease: FlxEase.quartOut});
		FlxTween.tween(leftCamera, {y: 0}, 1, {ease: FlxEase.quartOut});
	} else if (curStep == 912) {
		leftCamera.visible = rightCamera.visible = true;
		FlxTween.tween(rightCamera, {y: 720}, 1, {ease: FlxEase.quartOut});
		FlxTween.tween(leftCamera, {y: -720}, 1, {ease: FlxEase.quartOut});
	} else if (curStep == 916) {
		leftCamera.visible = rightCamera.visible = false;
		FlxG.cameras.remove(leftCamera, false);
		FlxG.cameras.remove(rightCamera, false);
	}
}
