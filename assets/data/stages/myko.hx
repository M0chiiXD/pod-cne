import funkin.backend.shaders.FunkinShader;
import openfl.filters.ShaderFilter;
import openfl.display.BlendMode;
import funkin.backend.shaders.BloomEffect;

var bloom:BloomEffect = new BloomEffect(50, 50, 18, 0.05, 0.365, 0.8);

function create() {
	for (camera in FlxG.cameras.list) {
		camera.filters ??= [];
	}

	camGame.filters.push(bloom);

	white = new FlxSprite();
    white.makeGraphic(2000, 2000, FlxColor.WHITE);
    white.scrollFactor.set(0, 0);
	white.scale.set(10, 10);
    white.cameras = [camGame];
	add(white);
	
	white.blend = BlendMode.OVERLAY;
	
	FlxTween.tween(frontclouds, {y: frontclouds.y - 55}, 3.5, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
}

var colorMap:Array = [0xFFFF00FF, 0xFF00FFFF, 0xFFFFFF00, 0xFF008000, 0xFF800080];
var curColor:Int = 0;

public var minty:Bool = false;
public var bloomBop:Bool = false;
public var beatBop:Int = 2;
public var bloomFX:Array = [18, 0.85, 0.085, 2];

function beatHit() {
	if (minty) {
		curColor = FlxG.random.int(0, colorMap.length - 1, [curColor]);
		white.color = colorMap[curColor];
		white.visible = true;
	} else {
		white.color = FlxColor.WHITE;
		white.visible = false;
	}

	if (bloomBop && curBeat % bloomFX[3] == 0) bloom.strength = bloomFX[1];
	
	white.alpha = 0.55;
	FlxTween.tween(white, {alpha: 0.2}, 0.55, {ease: FlxEase.cubeInOut});
}

function update() {
	bloom.strength = lerp(bloom.strength, 0.05, bloomFX[2]);
}
