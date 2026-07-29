function postCreate() {
	//cam scale
	camGame.targetOffset.x = camHUD.x = camGame.x = 140;
	camHUD.width = camGame.width = 1000;
	camHUD.height = camGame.height =  720;
	
	//hud pos
	healthBar.x = 210;
	healthBarBG.x = 205;
	missesTxt.x = 250;
}

function onStrumCreation(e)
{
	e.strum.x -= (5 / 32) * strumLines.members[e.player].startingPos.x + 75;
	e.strum.y = Options.downscroll ? 70 : 35;
}

