// TODO: tweak the splash screen more
var phant = Paths.font("PhantomMuff.ttf");

function create(){
	codename = new FunkinSprite(0, 0, Paths.image("menus/splashes/cneSplash"));
	codename.updateHitbox();
	codename.screenCenter();
	codename.addAnim("splash", "splash", 18, false);
	codename.scale.set(0.6, 0.6);
	codename.visible = false;
	add(codename);
	
	hyperGen = new FlxSprite(0, 0);
    hyperGen.loadGraphic(Paths.image("menus/splashes/hypergenLogo"));
	hyperGen.scale.set(0.15, 0.15);
    hyperGen.updateHitbox();
    hyperGen.screenCenter();
	hyperGen.alpha = 0;
    add(hyperGen);
	
	hyperGentext = new FlxText(0, 190, 1500, "A\n\n\n\n\n\n\n\nHyperGeneric Project");
	hyperGentext.setFormat(phant, 32, FlxColor.WHITE, "center");
	hyperGentext.scrollFactor.set(0, 0);
	hyperGentext.updateHitbox();
	hyperGentext.screenCenter();
    add(hyperGentext);
	
	playSplash(0);
}

var curSplash:Int = 0;
function playSplash(splash:Int) {
	switch (splash) {
		case 0:
			curSplash = 0;
			codename.playAnim("splash");
			FlxG.sound.play(Paths.sound("splash/cne logo"));
			codename.visible = true;
			new FlxTimer().start(3, (_) -> playSplash(1));
		case 1:
			FlxTween.tween(codename, {alpha: 0}, 0.8, {ease: FlxEase.quartIn, onComplete: function() {
			playSplash(2);
			}});
		case 2:
			curSplash = 1;
			codename.visible = false;
			FlxG.sound.play(Paths.sound("splash/startup2"));
			FlxTween.tween(hyperGen.scale, {x: 0.2, y: 0.2}, 0.8, {ease: FlxEase.quartOut});
			FlxTween.tween(hyperGen, {alpha: 1}, 0.8, {ease: FlxEase.quartIn, onComplete: function() {
			playSplash(3);
			}});
		case 3:
			FlxTween.tween(hyperGen, {alpha: 0}, 3, {ease: FlxEase.quartIn, onComplete: function() {
			playSplash(4);
			}});
		case 4:
			curSplash = 2;
			hyperGen.visible = false;
			startMod();
	}	
}

function update() {
	hyperGentext.alpha = hyperGen.alpha;
	if (controls.ACCEPT) {
		startMod();
	}
}

function startMod() {
	new FlxTimer().start(0.12, (_) -> FlxG.switchState(new MainMenuState()));
}
