function onNoteHit(event) {
    if (event.noteType == "Parry") {
		event.cancelAnim();
		bf.playAnim("shoot", true, "sing");
	}
}