import flixel.FlxCamera;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.savedata.FunkinSave;

var windowCam = new FlxCamera();
var newTab = new FlxCamera();
var songInfo = new FlxCamera();
var tabHandler = new FlxCamera(0, 0, FlxG.width, FlxG.height * 0.08);
var songs;
var lines = 0;
var songCount = 0;
var songIcons:FlxTypedGroup = [];
var linkSets:Array<String> = ["www.packofdoom.pod/songinfo"];
var tabs:Array = ["New Tab", "Song Info", "Extras"];
var isEvil = false;
var awesome;
var curSelected = 0;

var overlokeThemeColor = 0xFF6f819e;

var trans:Bool = false;

function create() {	
	FlxG.sound.music.fadeOut(0.3);
	
	windowCam.bgColor = 0x88000000;
	windowCam.alpha = 1;
	windowCam.zoom = 0.5;
	windowCam.height = FlxG.height * 3;
	tabHandler.bgColor = overlokeThemeColor;
	newTab.bgColor = overlokeThemeColor;
	tabHandler.alpha = 0;
	songInfo.alpha = 0;
	
	songs = FreeplaySonglist.get().songs;
	
	trans = true;
	
	windowBase = new FlxSprite(0, 0);
	windowBase.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	windowBase.alpha = 1;
	windowBase.scrollFactor.set();
	windowBase.updateHitbox();
	windowBase.camera = windowCam;
	add(windowBase);
	
	windowBG = new FlxSprite(0, 0);
	windowBG.makeGraphic(FlxG.width, FlxG.height, 0xFF3a4352);
	windowBG.alpha = 1;
	windowBG.scrollFactor.set();
	windowBG.updateHitbox();
	windowBG.camera = songInfo;
	add(windowBG);
	
	add(songIcons);
	
	backerLOL = new FlxSprite(-200, 200);
	backerLOL.makeGraphic(175, 175, FlxColor.WHITE);
	backerLOL.updateHitbox();
	backerLOL.camera = songInfo;
	add(backerLOL);
	
	for (i => icons in songs) {
        if (songCount > 0 && songCount % 3 == 0){
            lines += 1;
        }
		
		var awesome = getSongIcon(songs[i].name);
		var overlokeIcons = new FlxSprite();
		overlokeIcons.loadGraphic(awesome);
		overlokeIcons.setGraphicSize(165, 165);
		overlokeIcons.updateHitbox();
		overlokeIcons.camera = songInfo;
		var spaceMult = overlokeIcons.width + 25;
		overlokeIcons.setPosition(50 + spaceMult * songCount % 3, 120 + spaceMult * lines);
		add(overlokeIcons);
		
		songIcons.push(overlokeIcons); 
		songCount += 1;
	}
	
	viewBase = new FlxSprite(FlxG.width / 2, 0);
	viewBase.makeGraphic(FlxG.width / 2, FlxG.height, 0xFF6f819e);
	viewBase.alpha = 1;
	viewBase.scrollFactor.set();
	viewBase.updateHitbox();
	viewBase.camera = songInfo;
	add(viewBase);

	var curIcon = getSongIcon(songs[curSelected].name);
	curSongArt = new FlxSprite().loadGraphic(curIcon);
	curSongArt.setGraphicSize(260, 260);
	curSongArt.scrollFactor.set();
	curSongArt.camera = songInfo;
	add(curSongArt);

	var hfont = Paths.font("PhantomMuff.ttf");
	songTitle = new FlxText((FlxG.width / 2) + 10, 360, 500, "Discord").setFormat(hfont, 50, FlxColor.BLACK, "left");
	songTitle.scrollFactor.set(0, 0);
	songTitle.camera = songInfo;
	songTitle.updateHitbox();
	add(songTitle);

	songCred = new FlxText(FlxG.width - 455, 140, 430, "Song: X\nArt: X\nChart: X").setFormat(hfont, 34.5, FlxColor.BLACK, "right");
	songCred.scrollFactor.set(0, 0);
	songCred.camera = songInfo;
	songCred.updateHitbox();
	add(songCred);

	songDesc = new FlxText((FlxG.width / 2) + 20, 430, 500, "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore").setFormat(hfont, 35, FlxColor.BLACK, "left");
	songDesc.scrollFactor.set(0, 0);
	songDesc.camera = songInfo;
	songDesc.updateHitbox();
	add(songDesc);

	exit = new FlxSprite(FlxG.width - 53, 5).loadGraphic(Paths.image('menus/gallery/close'));
	exit.setGraphicSize(50, 50);
	exit.updateHitbox();
	exit.scrollFactor.set();
	exit.alpha = 0.8;
	exit.cameras = tabHandler;
	add(exit);

	curTab = 0;
	curSelected = 0;
	backerLOL.setPosition(songIcons[curSelected].x - 5, songIcons[curSelected].y - 5);
	songData = FunkinSave.getSongHighscore(songs[curSelected].name, (!isEvil) ? "normal" : "evil");

	updateInfoPanel();
	
	FlxTween.tween(windowCam, {zoom: 1}, 0.5, {ease: FlxEase.cubeOut, onComplete: (_) ->
		loadApp()
	});
}

function postCreate() {
	FlxG.cameras.add(windowCam, false);
	FlxG.cameras.add(songInfo, false);
	FlxG.cameras.add(newTab, false);
	FlxG.cameras.add(tabHandler, false);
}

function makeSongIcon(songName:String, xPos:Int, yPos:Int) {
	var b = new FlxSprite().loadGraphic(Paths.image("menus/gallery/overloke/icons" + songName));
	b.scale.set(0.6, 0.6);
	b.updateHitbox();
	b.x = xBtn;
	b.y = yBtn;
	b.camera = songInfo;
    add(b);
	return(b);
}

function getCurrentTab(tab:Int) {
	//stuff here soon ;)
}

function update() {
	for (i in 0...songIcons.length) {
		if (songInfo.alpha == 1 && FlxG.mouse.overlaps(songIcons[i]) && FlxG.mouse.justPressed) {
			curSelected = i;
			backerLOL.setPosition(songIcons[curSelected].x - 5, songIcons[curSelected].y - 5);
			updateInfoPanel();
		}
	}
	newTab.alpha = tabHandler.alpha = 0;
}

function updateInfoPanel() {
	songTitle.text =  getSongTitle();
	var curIcon = getSongIcon(songs[curSelected].name);
	curSongArt.loadGraphic(curIcon);
	curSongArt.setGraphicSize(260, 260);
	curSongArt.updateHitbox();
	curSongArt.setPosition((FlxG.width / 2) + 12, 80);
	viewBase.color = songs[curSelected].color;
	songTitle.color = songCred.color = songDesc.color = FlxColor.BLACK;
	var darkArray = ["burned", "carnivorous", "thats-kinda-sus", "my-dog", "red-and-arrow"];
	for (item in darkArray) {
		if (songs[curSelected].name == item)
			songTitle.color = songCred.color = songDesc.color = FlxColor.WHITE;
	}
//	songDesc.text = getSongDesc();
}

function getSongTitle() {
	if (songData.score != 0) {
		if (!isEvil) return songs[curSelected].displayName;
		else return songs[curSelected].displayName + "(Evil)";
	}
	else return "???";
}

function getSongIcon(song:String) {
	if (Assets.exists(Paths.image("menus/gallery/overloke/icons/" + song))) {
		return Paths.image("menus/gallery/overloke/icons/" + song);
	} else {
		return Paths.image("menus/warningBG");
	}
}

function getSongDesc() {
	var descPath = Paths.getPath("config/overlokeCredits/desc/" + songs[curSelected].name);
	if (Assets.exists(descPath)) {
		return CoolUtil.coolTextFile(descPath).join("\n");
	} else {
		return "Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore";
	}
}

var scrollY:Float = 0;
function postUpdate(elapsed:Float) {
	if (FlxG.mouse.justPressed) {
		FlxG.sound.play(Paths.sound("gallery/click"));
	}
	
	FlxG.camera.scroll.y = songInfo.scroll.y = lerp(songInfo.scroll.y, (scrollY = FlxMath.bound(FlxG.mouse.wheel != 0 ? scrollY - FlxG.mouse.wheel * 60 : scrollY, 0, songIcons.length * 50)), 0.1);

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
}

function loadApp() {
	FlxTween.tween(tabHandler, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	trans = false;
	CoolUtil.playMusic(Paths.music("get browsing, the website is probably underground"));
}

function closeWindow() {
	CoolUtil.playMusic(Paths.music("orbindos"));
	FlxG.sound.music.fadeIn(1);
	tabHandler.alpha = 0;
	FlxTween.tween(windowCam, {alpha: 0}, 0.3, {ease: FlxEase.cubeOut});
	FlxTween.tween(windowCam, {zoom: 0.5}, 0.3, {ease: FlxEase.cubeOut, onComplete: (_) -> close() });
}
