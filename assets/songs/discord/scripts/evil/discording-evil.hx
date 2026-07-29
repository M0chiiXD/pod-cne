importScript("data/scripts/squareResize");
importScript("data/scripts/evilScript");

var usop = stage.getSprite("usoptjdtpidsfnr");

function postCreate() {
	cpu.characters[0].visible = false;
	
	jumpscare = new FlxSprite().loadGraphic(Paths.image("game/evildiscordjumpscare"));
	jumpscare.visible = false;
	jumpscare.camera = camHUD;
	add(jumpscare);
	
	mesmerizer = new FunkinSprite(-670, -300, Paths.image('stages/_other/thewavybg'));
	mesmerizer.addAnim("idle", "idle", 15, true);
	mesmerizer.scale.set(10, 10);
	mesmerizer.updateHitbox();
	mesmerizer.camera = camGame;
	mesmerizer.scrollFactor.set(0.15, 0.9);
	mesmerizer.playAnim("idle");
	mesmerizer.visible = false;
	insert(members.indexOf(dad, bf), mesmerizer);
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 64:
			triggerEVIL();
			cpu.characters[0].visible = true;
			cpu.characters[1].visible = false;
		case 730:
			jumpscare.visible = true;
			hideEVIL();
		case 736:
			jumpscare.visible = false;
			triggerEVIL();
		case 755:
			cpu.characters[0].visible = false;
			cpu.characters[1].visible = true;
		case 758:
			cpu.characters[0].visible = true;
			cpu.characters[1].visible = false;
		case 766:
			camGame.angle = 180;
		case 768:
			camGame.angle = 0;
		case 1152:
			mesmerizer.visible = true;
			usop.visible = false;
		case 1664: 
			mesmerizer.visible = false;
			usop.visible = true;
		case 1776:
			hideEVIL();
			cpu.characters[0].visible = false;
			cpu.characters[1].visible = true;
	}
}