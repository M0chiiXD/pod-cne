function create() {
	piano.addAnim("idle", "piano idle", 12, true);
	violin.addAnim("idle", "violin idle", 12, true);
	drums.addAnim("idle", "drums idle", 12, true);

	piano.playAnim("idle");
	violin.playAnim("idle");
	drums.playAnim("idle");
}