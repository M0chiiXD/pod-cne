function postCreate() {
	blacktriangle.addAnim("idle", "black triangle idle", 12, false);
	lightinging.addAnim("idle", "lightinging idle", 12, false);
	star1.addAnim("idle", "star 1 idle", 12, false);
	star2.addAnim("idle", "star 2 idle", 12, false);
	brown.addAnim("idle", "brown idle", 12, false);
}

function stepHit(curStep:Int) {
	switch (curStep){
		case 768: 
			for (bgGuys in [sprite_3, sprite_5, sprite_6, star1, star2, brown, blacktriangle, texty, lightinging]) 
				bgGuys.visible = false;
		case 1024:
			for (bgGuys in [sprite_3, sprite_5, sprite_6, star1, star2, brown, blacktriangle, texty, lightinging]) 
				bgGuys.visible = true;
    }
}