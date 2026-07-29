import flixel.FlxCamera;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.savedata.FunkinSave;

// please excuse my code below it may be sloppy :pleading_face: - m0chimyra

var tabHandler = new FlxCamera(0, 0, FlxG.width, FlxG.height * 0.085); //
var newTab = new FlxCamera();
var songInfo = new FlxCamera();
var extras = new FlxCamera();
var windowCam = new FlxCamera();

var songData;

var trans:Bool = false;

var tabNames:Array  = ["New Tab", "Song Info", "Extras"];
var tabsList:Array<String>;

var phant = Paths.font("PhantomMuff.ttf");

var curTab;

// song info vars
var songs;
var lines = 0;
var songCount = 0;
var songIcons:FlxTypedGroup = [];
var isEvil = false;
var awesome;
var curSong = 0;

var overlokeThemeColor = 0xFF6f819e;

function create() {
	FlxG.sound.music.fadeOut(0.3);

	windowCam.bgColor = 0x88000000;
	windowCam.zoom = 0.5;
	tabHandler.bgColor = overlokeThemeColor;
	newTab.bgColor = overlokeThemeColor;
	songInfo.bgColor = overlokeThemeColor;

	tabHandler.alpha = 0;
	newTab.visible = songInfo.visible = extras.visible = false;

	songs = FreeplaySonglist.get().songs;

	trans = true;

	windowBase = new FlxSprite(0, 0);
	windowBase.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	windowBase.alpha = 1;
	windowBase.scrollFactor.set();
	windowBase.updateHitbox();
	windowBase.camera = windowCam;
	add(windowBase);

	tabHitbox = new FlxSprite(0, FlxG.height * 0.085).makeGraphic(FlxG.width, FlxG.height - (FlxG.height * 0.085), 0xFF000000);
	tabHitbox.alpha = 0.5;
	tabHitbox.scrollFactor.set();
	tabHitbox.updateHitbox();
	tabHitbox.cameras = [newTab, songInfo, extras];
	add(tabHitbox);

	// song info stuff
	// --------------------------
	backerLOL = new FlxSprite(-200, 200);
	backerLOL.makeGraphic(175, 175, FlxColor.WHITE);
	backerLOL.updateHitbox();
	backerLOL.camera = songInfo;
	add(backerLOL);

	add(songIcons);

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

	var curIcon = getSongIcon(songs[curSong].name);
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

	curSong = 0;
	backerLOL.setPosition(songIcons[curSong].x - 5, songIcons[curSong].y - 5);
	songData = FunkinSave.getSongHighscore(songs[curSong].name, (!isEvil) ? "normal" : "evil");

	updateInfoPanel();
	// --------------------------

	exit = new FlxSprite(FlxG.width - 53, 5).loadGraphic(Paths.image('menus/gallery/close'));
	exit.setGraphicSize(50, 50);
	exit.updateHitbox();
	exit.scrollFactor.set();
	exit.alpha = 0.8;
	exit.camera = tabHandler;
	add(exit);

	tabsList = [ for (v in 0...tabNames.length) makeNewTab(tabNames[v], (v * 258) + 2) ];

	curTab = FlxG.save.data.lastTabOpened;

	FlxTween.tween(windowCam, {zoom: 1}, 0.5, {ease: FlxEase.cubeOut,
	onComplete: (_) -> loadApp() });
}

function postCreate() {
	FlxG.cameras.add(windowCam, false);
	FlxG.cameras.add(newTab, false);
	FlxG.cameras.add(songInfo, false);
	FlxG.cameras.add(extras, false);
	FlxG.cameras.add(tabHandler, false);
}

var onTabs:Bool;
function update() {
	// tab handler
	for (x in 0...tabsList.length) {
		tabsList[x].y = 20;
		tabsList[curTab].y = 15;
		if (!onTabs && CoolUtil.mouseOverlaps(tabsList[x], tabHandler)) {
			if (FlxG.mouse.justPressed) {
				curTab = x;
				getCurrentTab(curTab);
			}
		}
		tabsList[x].alpha = 0.5;
		tabsList[curTab].alpha = 1;
	}

	onTabs = FlxG.mouse.overlaps(tabHitbox);

	if (onTabs) { //checks if you're hovering on the tab space

		// song info handler
		for (i in 0...songIcons.length) {
			if (CoolUtil.mouseOverlaps(songIcons[i], songInfo) && FlxG.mouse.justPressed) {
				curSong = i;
				backerLOL.setPosition(songIcons[curSong].x - 5, songIcons[curSong].y - 5);
				updateInfoPanel();
			}
		}

	}
}

// tab handler functions
function makeNewTab(name:String, xVal:Int, ?cam:FlxCamera) {
	var tab = new FlxSprite(xVal, 20).makeGraphic(FlxG.width * 0.2, 50, 0xFF4f5a6e);
	tab.camera = tabHandler;
	add(tab);

	txt = new FlxText(tab.x + 10, 26, 200, name);
	txt.setFormat(phant, 25, FlxColor.WHITE, "left");
	txt.scrollFactor.set();
	txt.camera = tabHandler;
	txt.updateHitbox();
	txt.alpha = tab.alpha;
	add(txt);

	return(tab);
	return(txt);
}

function getCurrentTab(tab:Int) {
	switch (tab) {
		case 0:
			newTab.visible = true;
			songInfo.visible = extras.visible = false;
		case 1:
			songInfo.visible = true;
			newTab.visible = extras.visible = false;
		case 2:
			extras.visible = true;
			newTab.visible = songInfo.visible = false;
	}
}

// song info handler functions
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

function updateInfoPanel() {
	songTitle.text =  getSongTitle();
	var curIcon = getSongIcon(songs[curSong].name);
	curSongArt.loadGraphic(curIcon);
	curSongArt.setGraphicSize(260, 260);
	curSongArt.updateHitbox();
	curSongArt.setPosition((FlxG.width / 2) + 12, 80);
	viewBase.color = songs[curSong].color;
	songTitle.color = songCred.color = songDesc.color = FlxColor.BLACK;
	var darkArray = ["burned", "carnivorous", "thats-kinda-sus", "my-dog", "red-and-arrow"];
	for (item in darkArray) {
		if (songs[curSong].name == item)
			songTitle.color = songCred.color = songDesc.color = FlxColor.WHITE;
	}
	//	songDesc.text = getSongDesc();
}

function getSongTitle() {
	if (songData.score != 0) {
		if (!isEvil) return songs[curSong].displayName;
		else return songs[curSong].displayName + "(Evil)";
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
	var descPath = Paths.getPath("config/overlokeCredits/desc/" + songs[curSong].name);
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

	if (curTab == 1) songInfo.scroll.y = lerp(songInfo.scroll.y, (scrollY = FlxMath.bound(FlxG.mouse.wheel != 0 ? scrollY - FlxG.mouse.wheel * 60 : scrollY, 0, songIcons.length * 50)), 0.1);

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
	FlxTween.tween(newTab, {alpha: 1}, 0.2, {ease: FlxEase.linear});
	trans = false;
	getCurrentTab(FlxG.save.data.lastTabOpened);
	CoolUtil.playMusic(Paths.music("get browsing, the website is probably underground"));
}

function closeWindow() {
	CoolUtil.playMusic(Paths.music("orbindos"));
	FlxG.sound.music.fadeIn(1);
	FlxG.save.data.lastTabOpened = curTab;
	newTab.alpha = songInfo.alpha = extras.alpha = tabHandler.alpha = 0;
	FlxTween.tween(windowCam, {alpha: 0}, 0.3, {ease: FlxEase.cubeOut});
	FlxTween.tween(windowCam, {zoom: 0.5}, 0.3, {ease: FlxEase.cubeOut, onComplete: (_) -> close() });
}
