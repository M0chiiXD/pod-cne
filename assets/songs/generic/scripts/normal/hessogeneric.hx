var car = stage.getSprite("car");

function postCreate(){
	car.y -= 50;
}

function stepHit(curStep:Int) {
    if (curStep == 1286) {
		FlxTween.tween(car, {x: dad.getPosition().x + 160}, 0.4, {ease: FlxEase.backOut});
	}
}
