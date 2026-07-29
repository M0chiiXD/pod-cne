import flixel.addons.effects.FlxTrail;
import openfl.display.BlendMode;
import flixel.addons.display.FlxBackdrop;

public var aquaTrail:FlxTrail;

var distort:CustomShader;
var bloom:CustomShader;
var rain:CustomShader;

function postCreate(){
    rain = new CustomShader("rain");
	camGame.addShader(rain);
    rain.intensity = 0.1;
    rain.iTimescale = 0.8;
	
	distort = new CustomShader("waterDistortion");
	distort.strength = 0.1;
	camGame.addShader(distort);
	
	//chase 1 bg
	sky1 = new FlxBackdrop(Paths.image("stages/burned/chase1/sky1"), FlxAxes.X);
	sky1.scale.set(2, 2);
//	sky1.y = -90;
	sky1.scrollFactor.set(0.8, 1);
	
	chaseBack1 = new FlxBackdrop(Paths.image("stages/burned/chase1/backtree67"), FlxAxes.X);
	chaseBack1.scale.set(2.4, 2.4);
	chaseBack1.y = 85;
	chaseBack1.scrollFactor.set(0.9, 1);
	
	chaseBG1 = new FlxBackdrop(Paths.image("stages/burned/chase1/groundpound"), FlxAxes.X);
	chaseBG1.scale.set(3, 3);
	chaseBG1.y = 35;
	chaseBG1.scrollFactor.set(0.9, 1);
	
	chaseFront1 = new FlxBackdrop(Paths.image("stages/burned/chase1/fourground"), FlxAxes.X);
	chaseFront1.scale.set(2.5, 2.5);
	chaseFront1.y = 30;
	chaseFront1.scrollFactor.set(0, 0);
	
	bpLegs = new FunkinSprite(dad.x + 120, 448, Paths.image("characters/burned/brp_runlegs"));
	bpLegs.scale.set(1.1, 1.1);
	bpLegs.addAnim("run", "run", 14, true);
	azLegs = new FunkinSprite(bf.x - 136, 465, Paths.image("characters/burned/azb_runlegs"));
	azLegs.scale.set(1.1, 1.1);
	azLegs.addAnim("run", "run", 14, true);
	
	bpLegs.playAnim("run");
	azLegs.playAnim("run");
	
	//chase 2 bg
	//yeah there's nothing rn T^T
	
	//chase end bg
	skyfin = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/burned/chasefin/skyfin"));
	skyfin.scale.set(3, 3);
	skyfin.scrollFactor.set(1.2, 1.2);
	
	groundfin = new FlxSprite(0, 140).loadGraphic(Paths.image("stages/burned/chasefin/groundfin"));
	groundfin.scale.set(2.2, 2.2);
	
	treefin = new FlxSprite(0, 140).loadGraphic(Paths.image("stages/burned/chasefin/treefin"));
	treefin.scale.set(2.3, 2.3);
	treefin.scrollFactor.set(0.8, 0.8);
	
	stonedfin = new FlxSprite(-20, 360).loadGraphic(Paths.image("stages/burned/chasefin/stonedfin"));
	stonedfin.scale.set(2, 2);
}

var localTime:Float = 0;
function update(elapsed:Float){
    localTime += elapsed;
    rain.iTime = localTime;
    rain.iIntensity = 0.05;
    rain.iTimescale = 0.7;
	
	sky1.x -= 180 * elapsed;
	chaseBG1.x -= 16 * 180 * elapsed;
	chaseBack1.x -= 18 * 180 * elapsed;
	chaseFront1.x -= 20 * 180 * elapsed;
}

public function loadNextBG(bg:Int) {
	switch (bg) {
		case 1:
			for (bg1 in [stars, back, ground, front]) bg1.destroy();
			insert(members.indexOf(dad, bf), chaseBG1);
			insert(members.indexOf(chaseBG1), chaseBack1);
			insert(members.indexOf(chaseBack1), sky1);
			insert(members.indexOf(bf), azLegs);
			insert(members.indexOf(dad), bpLegs);
			add(chaseFront1);
		case 2:
			for (bg2 in [sky1, chaseBack1, chaseBG1, chaseFront1, azLegs, bpLegs]) bg2.destroy();
		case 3:
			insert(0, skyfin);
			insert(members.indexOf(dad, bf), groundfin);
			insert(members.indexOf(groundfin), treefin);
			insert(members.indexOf(bf), stonedfin);
		case 4:
			for (bg3 in [skyfin, groundfin, treefin, stonedfin]) bg3.destroy();
			dad.destroy();
			bf.destroy();
	}
}