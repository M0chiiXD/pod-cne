function onEvent(e) {
    var shake = e.event;

    if (e.event.name == 'Screen Shake') {
		var hudshake = shake.params[0];
		var steps:Int = shake.params[2];
		var time:Float = (Conductor.stepCrochet * 0.001) * Math.abs(steps);
		var axes = shake.params[3];
		var shakeAxis = 0x01;
		
		switch (axes) {
			case "X": shakeAxis = 0x01;
			case "Y": shakeAxis = 0x10;
			case "Both": shakeAxis = 0x11;
		}
		
		camGame.shake(shake.params[1], time, null, true, shakeAxis);
		if (hudshake) camHUD.shake(shake.params[1], time, null, true, shakeAxis);				
	}
} 
