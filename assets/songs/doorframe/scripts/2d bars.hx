var titlecard;

function create() {	
	titlecard = new FlxSprite();
    titlecard.loadGraphic(Paths.image("game/titlecards/doorframe_titlecard"));
	titlecard.screenCenter();
    titlecard.alpha = 1;
    titlecard.y = 150;
	titlecard.x = 300;
	titlecard.scale.set(1.1, 1,1);
    titlecard.cameras = [camHUD];
    insert(0, titlecard);
	
	VideoUtil.loadFromUrl(["https://cdn.discordapp.com/attachments/1428179727822098463/1432301658863304797/doorframe.mp4?ex=6a9004de&is=6a8eb35e&hm=f3ec2f19f38ce0a3617d05ff7ed420664765ba5d9aa93685418bc9eb37bcb2d6&"], [], camHUD);
	
	camHUD.fade(FlxColor.BLACK, 0, false);
	camGame.fade(FlxColor.BLACK, 0, false);
}

function onSongStart(){
	camHUD.fade(FlxColor.BLACK, 0, true);
	VideoUtil.playNext();
}

function stepHit(curStep:Int) {
	if (curStep == 128) {
		camGame.fade(FlxColor.BLACK, 0, true);
		camHUD.alpha = 1;
	} else if (curStep == 129) {
		FlxTween.tween(titlecard.scale, { x: 1.2, y: 1.2 }, 3, {ease: FlxEase.quadOut});
	} else if (curStep == 164) {
		FlxTween.tween(titlecard, {alpha: 0,}, 2.3, {ease: FlxEase.quadInOut});
    }
}
