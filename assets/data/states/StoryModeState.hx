import flixel.tweens.FlxTween;
import funkin.menus.StoryMenuState;
import funkin.savedata.FunkinSave;

persistentDraw = persistentUpdate = true;

var scoretxt:FlxText;

var weeks:Array<dynamic> = [
	{
		"name": "Discord",
		"songs": [{"name": "discord"}],
		"id": 0
	},
	{
		"name": "Mirage",
		"songs": [{"name": "mirage"}],
		"id": 1
	},
	{
		"name": "Glassy",
		"songs": [{"name": "glassy-song"}],
		"id": 2
	},
	{
		"name": "TM",
		"songs": [{"name": "tm"}],
		"id": 3
	},
	{
		"name": "Burned",
		"songs": [{"name": "burned"}, {"name": "carnivorous"}],
		"id": 4
	}
];

public static var lastMenu:String;
public static var justPlayed:Bool;

var weekIndex:Int = 0;
var weekText:FlxText;

var portraits:Array = [];

var portrait:FunkinSprite;

var scoreFont = Paths.font("HelveticaNeueMedium.otf"); //temp font

function create() {
	lastMenu = "StoryMode";
	justPlayed = false;
	
	PlayState.isStoryMode = true;
	
	FlxG.camera.zoom = 1.5;
	FlxTween.tween(FlxG.camera, {zoom: 1}, 0.8, {ease: FlxEase.quartOut});
	
	scoretxt = new FlxText();
	scoretxt.color = FlxColor.WHITE;
	scoretxt.font = scoreFont;
	scoretxt.size = 30;
	scoretxt.x = 0;
	scoretxt.y = 684;
	scoretxt.text = "1124670";
	add(scoretxt);
	
    for (i => week in weeks) {
        portrait = new FunkinSprite(i * (FlxG.width / weeks.length), 0, Paths.image("menus/storymenu/weeks/Menu_" + week.name));
        portrait.updateHitbox();
        portrait.addAnim("hover", "hover", 5, true);
        portrait.addAnim("idle", "idle", 24, false);
        portrait.playAnim("idle");
        add(portrait);
        portraits.push(portrait);
		
		FlxG.sound.cache(Paths.music("storymenu/" + week.name));
    }
	changeSelect(0);
}

function postCreate() {
	white = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
	white.blend = 0;
	white.alpha = 0;
	add(white);
	
	black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.PURPLE);
	black.blend = 0;
	black.alpha = 0;
	add(black);
}

var cur:Int;
var saveData:Int = 0;
var canScroll:Bool = true;

function update(elapsed:Float) {
	if (controls.LEFT_P || controls.RIGHT_P) changeSelect(controls.LEFT_P ? -1 : 1);
	if (controls.ACCEPT && canScroll) {
		weekLoad();
		canScroll = false;
	}
	if (controls.BACK) FlxG.switchState(new MainMenuState());
	for (i => week in weeks) {
		portraits[i].alpha = 0.6;
		portraits[cur].alpha = 1;
	}
	saveData = "Score: " + FunkinSave.getWeekHighscore(weeks[cur].id, "NORMAL").score;
	scoretxt.text = saveData;
}

var storyMusic:FlxSound;
function changeSelect(_:Int) {
	if (canScroll) {
		FlxTween.tween(portraits[cur], { y: 0 }, 0.15, {ease: FlxEase.circOut});
		portraits[cur].playAnim("idle");
		cur = FlxMath.wrap(cur + _, 0, portraits.length - 1);
		CoolUtil.playMusic(Paths.music("storymenu/" + weeks[cur].name));
		FlxG.sound.play(Paths.sound("scratch"), 1);
		portraits[cur].playAnim("hover");
		FlxTween.tween(portraits[cur], { y: -45 }, 0.15, {ease: FlxEase.circOut});
		scoretxt.x = portraits[cur].x;
	}
}

// FlxTween.tween(FlxG.sound.music, {volume:0.05}, 0.1); 
//^^ this is important later

function flashWhite() {
	white.alpha = 1;
	FlxTween.tween(white, {alpha: 0}, 0.5);
}

function flashBlack() {
	black.alpha = 1;
	FlxTween.tween(black, {alpha: 0}, 0.5);
}

function weekLoad() {
	canScroll = false;
	
	if (weeks[cur].name == "Burned") {
			FlxG.sound.play(Paths.sound("menu/confirm_burned"), 1);
			FlxTween.tween(portraits[cur], { y: 900 }, 2.2, {ease: FlxEase.circIn});
			FlxTween.tween(FlxG.camera, {zoom: 1.5, alpha: 0}, 2, {ease: FlxEase.quartIn});
			flashBlack(1);
			FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.2 }, 3, {onComplete: () -> selectWeek()}); 
		}	else {
			FlxG.sound.play(Paths.sound("menu/confirm_story"), 1);
			FlxTween.tween(portraits[cur], { y: 900 }, 1, {ease: FlxEase.circIn});
			FlxTween.tween(FlxG.camera, {zoom: 1.5, angle: 3, alpha: 0}, 1, {ease: FlxEase.backIn});
			flashWhite(1);
			FlxTween.tween(FlxG.sound.music, { pitch: -3, volume: 0.2 }, 2, {onComplete: () -> selectWeek()}); 
			scoretxt.alpha = 0;
   		}
}

function selectWeek() {
		PlayState.loadWeek(weeks[cur]);
		FlxG.switchState(new PlayState());
}
