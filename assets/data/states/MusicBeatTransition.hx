function create() {
	transitionTween.cancel();

	remove(blackSpr);
	remove(transitionSprite);

	transitionCamera.fade(0xFF000000, 0.3, newState == null, () -> {finish();}, true);
}