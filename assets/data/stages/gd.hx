import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;

importScript("data/scripts/evilScript");

var outlineShader:CustomShader = new CustomShader('outline');
var fireholer:FlxTypedEmitter<FlxParticle>;
var coolness:Bool = false;
var spaceship:FlxSprite;

function create() {
	light.alpha = 0.65;
	light.visible = false;
	
	spaceship = new FlxSprite(-1600, 100);
	spaceship.loadGraphic(Paths.image("stages/dash/ufo"));
	spaceship.cameras = [camGame];
	spaceship.scale.set(1.3, 1.3);
	insert(members.indexOf(light), spaceship);

	spike1 = new FlxSprite(-400, 850);
	spike1.loadGraphic(Paths.image("stages/dash/spike"));
	spike1.cameras = [camGame];
	spike1.shader = outlineShader;
	insert(members.indexOf(floor), spike1);
	
	spike2 = new FlxSprite(1800, 850);
	spike2.loadGraphic(Paths.image("stages/dash/spike"));
	spike2.cameras = [camGame];
	spike2.shader = outlineShader;
	insert(members.indexOf(floor), spike2);
}

function postCreate() {
	fireholer = new FlxTypedEmitter(0, 1000);
	fireholer.keepScaleRatio = true;
	fireholer.angle.set(-32, 33);
	fireholer.scale.set(0.2, 0.4, 0.3);
	fireholer.launchAngle.set(-70, -120);
	fireholer.lifespan.set(8, 12);
	fireholer.alpha.set(1, 1, 0, 0);
	fireholer.speed.set(700, 700);
	fireholer.width = 2000;
	fireholer.cameras = [camGame];
	
	for (i in 0...200) {
		var particle = new FlxParticle();
		particle.loadGraphic(Paths.image("stages/dash/normal"));
		fireholer.add(particle);
	}
	
	FlxTween.tween(spaceship, {y: spaceship.y - 100}, 0.8, {type: FlxTween.PINGPONG, ease: FlxEase.bounceOut});
}

var spikes:Bool;
var ooh:Bool;
var colorMap:Array = [0xFFFF00FF, 0xFF00FFFF, 0xFFFFFF00, 0xFF008000, 0xFF800080];
var curColor:Int = 0;

function beatHit() {
	curColor = FlxG.random.int(0, colorMap.length - 1, [curColor]);
	light.color = colorMap[curColor];
	light.alpha = 1;
	FlxTween.tween(light, {alpha: 0.65}, 0.5, {ease: FlxEase.cubeInOut});
	
	spikes = !spikes;
	
	if (ooh) {
		if (spikes) {
			FlxTween.tween(spike1, {y: 550}, 0.5, {ease: FlxEase.quartIn});
			FlxTween.tween(spike2, {y: 850}, 0.5, {ease: FlxEase.quartIn});
		} else {
			FlxTween.tween(spike2, {y: 550}, 0.5, {ease: FlxEase.quartIn});
			FlxTween.tween(spike1, {y: 850}, 0.5, {ease: FlxEase.quartIn});
		}
	} else {
		FlxTween.tween(spike1, {y: 850}, 0.5, {ease: FlxEase.quartIn});
		FlxTween.tween(spike2, {y: 850}, 0.5, {ease: FlxEase.quartIn});
	}
}

function stepHit(curStep:Int) {
	if (PlayState.difficulty != "evil") {	
	
	if (curStep == 128) {
		light.visible = true;
	} else if (curStep == 256) {
		fireholer.start(false, 0.4, 0);
		insert(members.indexOf(light), fireholer);
	} else if (curStep == 640) {
		fireholer.destroy();
		FlxTween.tween(spaceship, {x: 3000}, 15, {ease: FlxEase.quartInOut});
		bg.color = FlxColor.RED;
		floor.color = FlxColor.RED;
	} else if (curStep == 768) {
		ooh = true;
	} else if (curStep == 896) {
		ooh = false;
		spike1.destroy();
		spike2.destroy();
		outlineShader.strength = 0;
		bg.color = FlxColor.WHITE;
		floor.color = FlxColor.WHITE;
	}
		
	} else {
		if (curStep == 0) {
			light.visible = true;
			ooh = true;
			bg.color = FlxColor.RED;
			floor.color = FlxColor.RED;
			triggerEVIL();
		}
	}
}