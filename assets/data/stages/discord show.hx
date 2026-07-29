var bluePencil:FunkinSprite;
var furry:FunkinSprite;

function create() {
	blueGuy = new FunkinSprite(233, 519, Paths.image("stages/discord/blue guy"));
	blueGuy.scale.set(1, 1);
	blueGuy.addAnim("idle", "blue guy idle", 10, true);
	insert(members.indexOf(dad, bf), blueGuy);
	
	furry = new FunkinSprite(533, 521, Paths.image("stages/discord/furry"));
	furry.scale.set(1, 1);
	furry.addAnim("idle", "furry idle", 10, true);
	insert(members.indexOf(dad, bf), furry);
}

function postCreate() {
	blueGuy.playAnim("idle");
	furry.playAnim("idle");
	FlxG.camera.bgColor = FlxColor.WHITE;
}
