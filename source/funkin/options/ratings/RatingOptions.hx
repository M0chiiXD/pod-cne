package funkin.options.ratings;

import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import haxe.xml.Access;
import funkin.options.categories.*;
using StringTools;

class RatingOptions extends MusicBeatSubstate {
	public static var instance:RatingOptions;

	public function translate(id:String, ?args:Array<Dynamic>)
		return TU.translate(id, args);

	public var camRatings:FlxCamera;

	public var canSelect:Bool = true;
	public var bg:FlxSprite;
	public var coloredBG:FlxSprite;

	public var curOffset:Array<Int> = [0, 0, 0, 0];

	public var rating:FlxSprite;
	public var comboNums:FlxSpriteGroup;

	public var isSubState:Bool = false;

	public override function create() {
		super.create();
		instance = this;

		isSubState = FlxG.state != this;

		camRatings = new FlxCamera();
		camRatings.bgColor = 0xAA000000;
		FlxG.cameras.add(camRatings, false);

		bg = new FlxSprite(-80).loadAnimatedGraphic(Paths.image('menus/menuTransparent'));
		bg.camera = camRatings;
		bg.alpha = 0.5;
		add(bg);

		rating = new FlxSprite(Options.ratingOffsets[0], Options.ratingOffsets[1]).loadAnimatedGraphic(Paths.image('game/score/sick'));
		rating.scale.set(0.65, 0.65);
		rating.updateHitbox();
		rating.antialiasing = Options.antialiasing;
		rating.camera = camRatings;
		add(rating);

		// taken from psych source lol!!!!
		var seperatedScore:Array<Int> = [];
		for (i in 0...3) {
			seperatedScore.push(FlxG.random.int(0, 9));
		}

		comboNums = new FlxSpriteGroup(Options.ratingOffsets[2], Options.ratingOffsets[3]);
		comboNums.camera = camRatings;
		add(comboNums);

		var daLoop:Int = 0;
		for (i in seperatedScore) {
			var numScore:FlxSprite = new FlxSprite(43 * daLoop).loadGraphic(Paths.image('game/score/num' + i));
			numScore.camera = camRatings;
			numScore.antialiasing = Options.antialiasing;
			numScore.scale.set(0.65, 0.65);
			numScore.updateHitbox();
			comboNums.add(numScore);
			daLoop++;
		}

		var blackBox:FlxSprite = new FlxSprite().makeGraphic(420, 420, FlxColor.BLACK);
		blackBox.scrollFactor.set();
		blackBox.alpha = 0.6;
		blackBox.camera = camRatings;
		add(blackBox);
	}

	function initOffsets() {
		// will add to this later, pls remind me
	}

	public override function destroy() {
		super.destroy();
		if (camRatings != null) FlxG.cameras.remove(camRatings);
		instance = null;
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

			if (controls.BACK) {
				MusicBeatState.skipTransIn = true;
				close();
				Options.save();
				return;
			}

			if (controls.ACCEPT) //might get rid of this

			if (controls.LEFT_P || controls.RIGHT_P) // for precise positioning, will code later :b

		super.update(elapsed);
	}
}
