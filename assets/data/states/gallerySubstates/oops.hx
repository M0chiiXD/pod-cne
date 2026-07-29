function create() {
	fade = new FlxSprite(0, 0);
    fade.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    fade.alpha = 0;
    fade.scrollFactor.set();
    add(fade);
	FlxTween.tween(fade, {alpha: 1}, 0.6, {ease: FlxEase.quadInOut});
	
    trace("SubState Opened!");
}

function postUpdate(elapsed:Float) {
    if (controls.BACK) {
		close();
	}
}