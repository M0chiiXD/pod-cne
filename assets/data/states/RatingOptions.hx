var startMousePos:FlxPoint = new FlxPoint();
var startComboOffset:FlxPoint = new FlxPoint();

function postCreate() {
	trace("hey this works");

	rating.setPosition(Options.ratingOffsets[0] , Options.ratingOffsets[1]);
	comboNums.setPosition(Options.ratingOffsets[2], Options.ratingOffsets[3]);
}

function update(_){
	FlxG.mouse.getScreenPosition(camRatings, startMousePos);
	var onRatings = CoolUtil.mouseOverlaps(rating, camRatings);
	var onCombo = CoolUtil.mouseOverlaps(comboNums, camRatings);

	if (onRatings && !onCombo) {
		if (FlxG.mouse.pressed) {
			var x = Math.round((FlxG.mouse.deltaScreenX - startMousePos.x) + rating.x);
			var y = Math.round((FlxG.mouse.deltaScreenY- startMousePos.y) + rating.y);
			rating.setPosition(x, y);
		}
	} else if (onCombo && !onRatings) {
		if (FlxG.mouse.pressed) {
			var x = Math.round((FlxG.mouse.deltaScreenX - startMousePos.x) + comboNums.x);
			var y = Math.round((FlxG.mouse.deltaScreenY- startMousePos.y) + comboNums.y);
			comboNums.setPosition(x, y);
		}
	}

	Options.ratingOffsets[0] = rating.x;
	Options.ratingOffsets[1] = rating.y;
	Options.ratingOffsets[2] = comboNums.x;
	Options.ratingOffsets[3] = comboNums.y;
}
