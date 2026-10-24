import flixel.addons.util.FlxScene;
import foxlite.FoxScene;
import foxlite.FoxModel;
import foxlite.FoxShader;
import foxlite.texture.FoxTexture;
import foxlite.material.FoxMaterial;
import foxlite.mesh.FoxQuadMesh;
import foxlite.stencil.FoxStencilAction;
import foxlite.sky.FoxPanoramaSky;
import foxlite.flixel.FoxFlxSprite;
import foxlite.funkin.FoxFunkinSprite;
import foxlite.cache.FoxCache;
import foxlite.lights.FoxDirectionalLight;
import foxlite.flixel.FoxRenderMetrics;
import foxlite.renderer.FoxRenderer;
import foxlite.loaders.FoxLoaderUtil;
import flixel.FlxG;
import openfl.filters.BitmapFilter;
import foxlite.extras.FoxFPSCamera;

var studentPassersL:Array = ["pin", "bully_final"];
var studentPassersR:Array = ["JumpRope", "GottaSweep"];

var cam:FoxFPSCamera;

var pencil:FoxFlxSprite;
var baldi:FoxFlxSprite;

var school;
var blackOverlay:FlxSprite;
var thinkpad:FlxSprite;

function create() {
	FoxRenderer.initLibs();
	FoxLoaderUtil.initPathClass(Paths);
	
	var scene = new FoxScene(FlxG.width, FlxG.height);
	scene.scrollFactor.set(0, 0);
	scene.zoomFactor = 0;

	cam = new FoxFPSCamera();
	scene.foxCameras.push(cam);
	cam.enableControls = false;

	school = new FoxModel();
	school.loadOBJ("models/haha baldi.obj", ["NO_ALPHA_SCISSOR", "NO_SHADOW_CODE"]);
	scene.add(school);
	
	add(scene);
	
	var basics = FoxShader.fromAsset("foxlite/basic", ["UNSHADED"]);
	
	pencil = new FoxFunkinSprite(bf, FoxMaterial.create(["BILLBOARD", ["bitmap" => FoxTexture.wrap(bf.pixels)]]), .0027);
	pencil.material.renderPriority = 2;
	scene.add(pencil);
	pencil.y = .9;
	pencil.x = 1.25;
	pencil.z = 1.2;

	baldi = new FoxFunkinSprite(dad, FoxMaterial.create(basics), .0027);
	baldi.material.renderPriority = 2;
	scene.add(baldi);
	baldi.y = .78;
	baldi.x = -1.45;
	baldi.z = 1.2;
	
/*	blackOverlay = new FlxSprite(0, 720);
    blackOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    insert(0, blackOverlay);
	
	thinkpad = new FlxSprite();
	thinkpad.loadGraphic(Paths.image("stages/baldi/thinkpad"));
	thinkpad.alpha = 0;
	thinkpad.screenCenter();
	thinkpad.updateHitbox();
	thinkpad.cameras = [camHUD];
	insert(1, thinkpad);
	
	whiteout = new FlxSprite();
    whiteout.makeGraphic(660, 370, FlxColor.WHITE);
    whiteout.scrollFactor.set(0, 0);
	whiteout.screenCenter();
    whiteout.cameras = [camHUD];
    insert(members.indexOf(thinkpad), whiteout);
	
	blackout = new FlxSprite(330, 420);
    blackout.makeGraphic(170, 130, FlxColor.BLACK);
    blackout.scrollFactor.set(0, 0);
    blackout.cameras = [camHUD];
    insert(members.indexOf(thinkpad), blackout);
	
	check1 = new FlxSprite(368, 220);
    check1.loadGraphic(Paths.image("stages/baldi/Check"));
	check1.scale.set(2,2);
    check1.scrollFactor.set(0, 0);
    check1.cameras = [camHUD];
    insert(members.indexOf(thinkpad), check1);
	
	check2 = new FlxSprite(364, 290);
    check2.loadGraphic(Paths.image("stages/baldi/Check"));
	check2.scale.set(2,2);
    check2.scrollFactor.set(0, 0);
    check2.cameras = [camHUD];
    insert(members.indexOf(thinkpad), check2);
	
	wrong = new FlxSprite(361, 370);
    wrong.loadGraphic(Paths.image("stages/baldi/X"));
	wrong.scale.set(1.8,1.8);
    wrong.scrollFactor.set(0, 0);
    wrong.cameras = [camHUD];
    insert(members.indexOf(thinkpad), wrong);
	
	for (answers in [check1, check2, wrong]) answers.visible = false;
	
	equation = new FlxText();
	equation.color = FlxColor.BLACK;
	equation.text = "3 + 7 =";
	equation.font = Paths.font("comic-bald.ttf");
	equation.size = 50;
	equation.alpha = 0;
	equation.borderSize = 2;
	equation.x = 470;
	equation.y = 220;
	equation.cameras = [camHUD];
	insert(2, equation);
	
	answerT = new FlxText();
	answerT.color = FlxColor.BLACK;
	answerT.text = "";
	answerT.font = Paths.font("comic-bald.ttf");
	answerT.size = 50;
	answerT.alpha = 1;
	answerT.borderSize = 2;
	answerT.x = 540;
	answerT.y = 440;
	answerT.cameras = [camHUD];
	insert(2, answerT);
	
	charLeft = new FlxSprite(3500, 300);
	charLeft.loadGraphic(randomStudentL());
	charLeft.alpha = 1;
	charLeft.scale.set(3.3, 3.3);
	charLeft.updateHitbox();
	charLeft.cameras = [camGame];
	add(charLeft);

	charRight = new FlxSprite(-3500, 300);
	charRight.loadGraphic(randomStudentR());
	charRight.alpha = 1;
	charRight.scale.set(3.3, 3.3);
	charRight.updateHitbox();
	charRight.cameras = [camGame];
	add(charRight);*/
}

function update(_) {
//	whiteout.alpha = blackout.alpha = thinkpad.alpha;
	var cg = PlayState.instance.camGame;
	var ch = PlayState.instance.camHUD;
	var x = cg.scroll.x;
	var y = cg.scroll.y;
	cam.position.setTo(
		(x * .005 + 0.05) * 0.3,
		0.8 + y * .001 + .05, 2.5
	);
//	cam.rotation.x = -0.3 - y*.001;
	cam.rotation.y = x*.0001;
}

function destroy() {
	FoxCache.instance.freeResources();
}

var leftRun:Float = FlxG.random.int(784, 1152);
var rightRun:Float = FlxG.random.int(128, 446);
function stepHit(curStep:Int) {
	if (PlayState.difficulty == "normal"){
	if (curStep == 496) {
		FlxTween.tween(blackOverlay, {y: 0}, 1, {ease: FlxEase.bounceOut});
	} else if (curStep == 504) {
		for (guh in [thinkpad, equation])
			FlxTween.tween(guh, {alpha: 1}, 0.4);
	} else if (curStep == 544) {
		answerT.text = "10";
		check1.visible = true;
	} else if (curStep == 576) {
		equation.text = "9 - 5 =";
		answerT.text = "";
	} else if (curStep == 608) {
		answerT.text = "3";
		check2.visible = true;
	} else if (curStep == 640) {
		equation.text = "6 + 7 =";
		answerT.text = "";
	} else if (curStep == 672) {
		answerT.text = "676767";
		wrong.visible = true;
	} else if (curStep == 752) {
		for (guh in [thinkpad, whiteout, blackout, equation, answerT, check1, check2, wrong]) guh.destroy();
		blackOverlay.destroy();
		camHUD.bgColor = FlxColor.BLUE;
	} else if (curStep == 768) {
		camHUD.bgColor = 0;
	}
	
	else if (curStep == leftRun) {
		FlxTween.tween(charLeft, {x: -3500}, 3);
	} else if (curStep == rightRun) {
		FlxTween.tween(charRight, {x: 3500}, 3);
	}
	}
}

function randomStudentL() {
	var student:Float = FlxG.random.int(0, 1);
	
	for (i in 0...studentPassersL.length) {
		return Paths.image("stages/baldi/" + studentPassersL[student]);
	}
}

function randomStudentR() {
	var student:Float = FlxG.random.int(0, 1);
	
	for (i in 0...studentPassersR.length) {
		return Paths.image("stages/baldi/" + studentPassersR[student]);
	}
}