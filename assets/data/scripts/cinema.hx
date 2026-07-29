function create() {
	controlBar1 = new FlxSprite(0, 0).makeSolid(1280, 180, FlxColor.BLACK);
	controlBar1.screenCenter(FlxAxes.X);
	controlBar1.y = -100;
	controlBar1.cameras = [camHUD];
	insert(0, controlBar1);
	
	controlBar2 = new FlxSprite(0, 0).makeSolid(1280, 85, FlxColor.BLACK);
	controlBar2.screenCenter(FlxAxes.X);
	controlBar2.cameras = [camHUD];
	controlBar2.y = 645;
	insert(0, controlBar2);
}