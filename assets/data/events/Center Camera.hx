var tweenOn:Bool;
var offsetX:Int;

function onEvent(centerCam) {
	var cam = centerCam.event;
    if (centerCam.event.name == 'Center Camera') {
		curCameraTarget = -1;
		
		tweenOn = cam.params[0];
		offsetX = cam.params[1];
	
		if (tweenOn)
			camFollow.x = (dad.getCameraPosition().x + bf.getCameraPosition().x * 0.5) - offsetX;
		else {
			camFollow.x = (dad.getCameraPosition().x + bf.getCameraPosition().x * 0.5) - offsetX;
			FlxG.camera.snapToTarget();
		}
	}
}