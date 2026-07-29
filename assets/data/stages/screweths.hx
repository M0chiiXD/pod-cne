import flixel.util.FlxColor;

function create() {
	bgr.color = 0xFF3737;
	bgp.color = 0x00A2E8;
	bgp.alpha = 0;
}
function postUpdate(elapsed:Float) {		
	if (curCameraTarget == 0) {
		FlxTween.tween(bgp, {alpha: 0}, 0.5 * 15 * elapsed, {ease: FlxEase.linear});
	} else if (curCameraTarget == 1) {
		FlxTween.tween(bgp, {alpha: 1}, 0.5 * 15 * elapsed, {ease: FlxEase.linear});
	}
}
