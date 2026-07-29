function create() {
	blackbox = new FunkinSprite(-338, 216, Paths.image("stages/grounded/blackbox"));
	blackbox.scale.set(0.5, 0.5);
	blackbox.addAnim("idle", "blackbox idle", 12, false);
	insert(members.indexOf(dad, bf), blackbox);
}

function beatHit() {
	blackbox.playAnim("idle");
	fakeairy.playAnim("idle");
}


function postCreate() {
	FlxG.camera.bgColor = FlxColor.WHITE;
	
	bhd.addAnim("0", "bigheaddanielson left", 1, true);
	bhd.addAnim("1", "bigheaddanielson right", 2, true);

	fakeairy.addAnim("idle", "fakeairy idle", 12, false);
}

function update(){
	if (curCameraTarget == 0) bhd.playAnim("0");
	else if (curCameraTarget == 1) bhd.playAnim("1");
} 
