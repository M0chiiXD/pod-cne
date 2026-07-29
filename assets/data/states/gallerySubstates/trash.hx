import flixel.FlxCamera;
import flixel.text.FlxText.FlxTextBorderStyle;

final data:Array = Json.parse(Assets.getText(Paths.json('scrapped')));

var windowCam = new FlxCamera();
var fileCam = new FlxCamera();
var appCam = new FlxCamera();
var viewerCam = new FlxCamera();

var files:Array<String> = [];
var fileGroup:Array = [];

var trans:Bool = false;

var clickie:FlxSprite;

function create() {
	FlxG.sound.music.fadeOut(0.3);
	
	windowCam.bgColor = 0x88000000;
	windowCam.alpha = 1;
	windowCam.zoom = 0.5;
	
	fileCam.bgColor = 0x88000000;
	fileCam.alpha = 0;
	
	appCam.bgColor = FlxColor.TRANSPARENT;
	appCam.alpha = 0;
	
	viewerCam.bgColor = FlxColor.TRANSPARENT;
	viewerCam.alpha = 0;
	
	trans = true;
	
	windowBase = new FlxSprite(0, 0);
	windowBase.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	windowBase.alpha = 1;
	windowBase.scrollFactor.set();
	windowBase.updateHitbox();
	windowBase.cameras = [windowCam];
	add(windowBase);
	
	appBG = new FlxSprite(0, 0);
	appBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
	appBG.alpha = 0;
	appBG.scrollFactor.set();
	appBG.updateHitbox();
	appBG.cameras = [windowCam];
	add(appBG);
	
	files = [
	for (i in 0...data.files.length) {
		makeDeletedFile(data.files[i].name, data.files[i].icon, data.files[i].type, 0, 120 + 80 * i);
	}
	];
	
	layover = new FlxSprite(0, 0, Paths.image("menus/gallery/trash/trashlay"));
	layover.cameras = [appCam];
	layover.scale.set(1.5, 1.5);
	layover.updateHitbox();
    layover.scrollFactor.set();
	add(layover);
	
	exit = new FlxSprite(FlxG.width - 53, 5).loadGraphic(Paths.image('menus/gallery/close'));
	exit.setGraphicSize(50, 50);
	exit.alpha = 0.8;
	exit.updateHitbox();
	exit.camera = appCam;
	add(exit);
	
	filestxt = new FlxText();
	filestxt.color = FlxColor.WHITE;
	filestxt.text = "Deleted files: " + data.files.length;
	filestxt.font = bot;
	filestxt.size = 30;
	filestxt.borderStyle = FlxTextBorderStyle.OUTLINE;
	filestxt.borderColor = FlxColor.BLACK;
	filestxt.borderSize = 2;
	filestxt.x = 20;
	filestxt.y = 50;
	filestxt.cameras = [appCam];
	add(filestxt);
	
	dselect = new FlxSprite(0, -1000);
	dselect.makeGraphic(FlxG.width / 2, 70, FlxColor.WHITE);
	dselect.alpha = 0.3;
	dselect.updateHitbox();
	dselect.cameras = [fileCam];
	add(dselect);
	
	viewBase = new FlxSprite(FlxG.width / 2, 0);
	viewBase.makeGraphic(FlxG.width / 2, FlxG.height, FlxColor.GRAY);
	viewBase.alpha = 1;
	viewBase.scrollFactor.set();
	viewBase.updateHitbox();
	viewBase.cameras = [viewerCam];
	add(viewBase);
	
	vfiletxt = new FlxText();
	vfiletxt.color = FlxColor.WHITE;
	vfiletxt.text = "No File Selected";
	vfiletxt.font = bot;
	vfiletxt.size = 30;
	vfiletxt.borderStyle = FlxTextBorderStyle.OUTLINE;
	vfiletxt.borderColor = FlxColor.BLACK;
	vfiletxt.borderSize = 2;
	vfiletxt.x = viewBase.x + 20;
	vfiletxt.y = 20;
	vfiletxt.cameras = [viewerCam];
	add(vfiletxt);
	
	FlxTween.tween(windowCam, {zoom: 1}, 0.5, {ease: FlxEase.cubeOut, onComplete: (_) -> 
		loadApp()
	});
}

function makeDeletedFile(filename:String, file:String, filetype:String, xPos:Int, yPos:Int) {
	var file = new FlxSprite(xPos, yPos);
	file.makeGraphic(FlxG.width / 2, 70, FlxColor.GRAY);
	file.alpha = 0.9;
	file.updateHitbox();
	file.cameras = [fileCam];
	add(file);
	
	var collision = new FlxSprite(file.x, file.y);
	collision.makeGraphic(FlxG.width / 2, 70, FlxColor.TRANSPARENT);
	collision.updateHitbox();
	collision.cameras = [fileCam];
	add(collision);
	
	var filename = new FlxText(xPos + 100, yPos + 20, 400, filename + "." + filetype);
	filename.setFormat("VCR OSD Mono", 42, FlxColor.BLACK, "left");
	filename.borderStyle = FlxTextBorderStyle.OUTLINE;
	filename.borderColor = FlxColor.WHITE;
	filename.borderSize = 2;
	filename.scale.set(0.6, 0.6);
	filename.cameras = [fileCam];
	filename.updateHitbox();
    add(filename);
	
	fileGroup.push({
		file: file,
        collision: collision,
        filename: filename,
    });
	
	return(file);
	return(collision);
	return(filename);
}

var bot = Paths.font("vcr.ttf");
function postCreate() {
	FlxG.cameras.add(windowCam, false);
	FlxG.cameras.add(fileCam, false);
	FlxG.cameras.add(appCam, false);
	FlxG.cameras.add(viewerCam, false);
}

var scrollY:Float = 0;
var curFile:Int = -1;
function update(elapsed:Float) {
	if (FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound("gallery/click"));
	}
	
	if (FlxG.mouse.overlaps(exit) && !trans) {
		exit.alpha = 1;
		if (FlxG.mouse.justPressed) {
			closing = true;
			FlxG.sound.play(Paths.sound("gallery/click"));
			closeWindow();
		}
	} else {
		exit.alpha = lerp(exit.alpha, 0.8, 0.1);
	}
	
	FlxG.camera.scroll.y = fileCam.scroll.y = lerp(fileCam.scroll.y, (scrollY = FlxMath.bound(FlxG.mouse.wheel != 0 ? scrollY - FlxG.mouse.wheel * 60 : scrollY, 0, data.files.length * 50)), 0.1);
	
	for (i in 0...fileGroup.length) {
		var file = fileGroup[i];
			if (FlxG.mouse.overlaps(file.collision) && !FlxG.mouse.overlaps(viewBase) && FlxG.mouse.justPressed) {
				curFile = i;
				dselect.y = file.collision.y;
				vfiletxt.text = fileGroup[i].filename.text;
				selectFile();
				trace("Selected File: " + curFile);
		}
	}
}

function selectFile() {
	for (i in 0...fileGroup.length) {
		
	}
}

function loadApp() {
	FlxTween.tween(appCam, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	FlxTween.tween(appBG, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	FlxTween.tween(fileCam, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	FlxTween.tween(viewerCam, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	trans = false;
}

function closeWindow() {
	CoolUtil.playMusic(Paths.music("orbindos"));
	FlxG.sound.music.fadeIn(1);
	fileCam.alpha = 0;
	appCam.alpha = 0;
	viewerCam.alpha = 0;
	FlxTween.tween(windowCam, {alpha: 0}, 0.3, {ease: FlxEase.cubeOut});
	FlxTween.tween(windowCam, {zoom: 0.5}, 0.3, {ease: FlxEase.cubeOut, 
	onComplete: (_) -> close() });
}