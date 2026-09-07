import openfl.display.BlendMode;
import funkin.backend.scripting.events.NoteHitEvent;

var red = new CustomShader('red');

function create() {
	redOverlay = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.RED);
	redOverlay.camera = camHUD;
	redOverlay.alpha = 0.5;
	redOverlay.blend = BlendMode.HARDLIGHT;
	add(redOverlay);
	
	camHUD.addShader(red);
	red.uActive = 0.0;
	
	redOverlay.visible = false;
}

static function triggerEVIL(?overlay:Bool) {
	red.uActive = 1.0;
	if (overlay != null) redOverlay.visible = overlay;
	else redOverlay.visible = true;
}

static function hideEVIL() {
	red.uActive = 0.0;
	redOverlay.visible = false;
}