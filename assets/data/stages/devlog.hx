function update(elapsed:Float){	
	if (mouseOverlaps(cube, camGame) && FlxG.mouse.justPressed) {
			PlayState.loadSong("do-stuff", "normal", false, false);
			FlxG.switchState(new PlayState());
			trace('what the fuck');
	}
}

function mouseOverlaps(sprite:FlxBasic, ?camera:FlxCamera) {
	var camToCheck:FlxCamera = camera ?? sprite.camera;
	var posthing:FlxPoint = FlxG.mouse.getWorldPosition(camToCheck);

	return posthing != null && FlxMath.inBounds(posthing.x, sprite.x, sprite.x + sprite.width) && FlxMath.inBounds(posthing.y, sprite.y, sprite.y + sprite.height);
}
