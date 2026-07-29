//Assisted by itsljcool
import haxe.ds.StringMap;
import funkin.game.Stage;
var sprite:FlxSprite;

function onEvent(e) {
  var event = e.event;
  if (event.name != "Change Stage") return;
  switchStage(event.params[0]);
}


function switchStage(stageName:String) {
    if (stageName == null) stageName = "stage";
    stage.destroy();
    stage.kill();
    remove(stage, true);
    var allSprites = stage.stageSprites;
    for (sprite in allSprites) {
        if (sprite == null) continue;
        sprite.kill();
        sprite.destroy();
        remove(sprite, true);
    }
    add(stage = new Stage(stageName));
    for (strumLine in strumLines.members) {
        for (char in strumLine.characters) {
            remove(char, false);
            insert(members.indexOf(stage), char);
        }
    }
}