/*
this is a (kinda) port of the script by SenTCM, credits to him

(this looks nothing like their code)

made by silly borja please credit if used
*/

var camStatic = FlxG.save.data.camStable;

function update(){
if (!camStatic){
	if (curCameraTarget != -1) {
		switch (strumLines.members[curCameraTarget].characters[0].animation.curAnim.name){
			case "singLEFT", "singLEFT-alt": doCameraStuffEhehehe([-15.0, 0]);
			case "singDOWN", "singDOWN-alt": doCameraStuffEhehehe([0, 15.0]);
			case "singUP", "singUP-alt": doCameraStuffEhehehe([0, -15.0]);
			case "singRIGHT", "singRIGHT-alt": doCameraStuffEhehehe([15.0, 0]);
			default: doCameraStuffEhehehe([0, 0]);
		}
	}
}
}

function doCameraStuffEhehehe(offsets:Array<Float>){
    camGame.targetOffset.x = FlxMath.lerp(camGame.targetOffset.x, offsets[0], camGame.followLerp * 5.0);
    camGame.targetOffset.y = FlxMath.lerp(camGame.targetOffset.y, offsets[1], camGame.followLerp * 5.0);

    camGame.angle = FlxMath.lerp(camGame.angle, offsets[0] * 0.05, camGame.followLerp * 5.0 / 3);
}