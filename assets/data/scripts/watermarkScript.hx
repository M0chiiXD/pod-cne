static var watermarkType:String;
public var watermarkCam:FlxCamera;

static var flip:Bool;

var watermark:FlxSprite;

function create() {
	watermarkCam = new FlxCamera();
	watermarkCam.bgColor = 0x00000000;
    FlxG.cameras.add(watermarkCam, false);
	
	watermark = new FlxSprite();
	
	switch (watermarkType){
		case "flipaclip":
			watermark.loadGraphic(Paths.image("game/watermarks/flipaclip"));
			watermark.updateHitbox();
			watermark.setPosition(-FlxG.width + watermark.width + 10, FlxG.height + watermark.width + 10);
		case "ibis1":
			watermark.loadGraphic(Paths.image("game/watermarks/ibisPaint"));
			watermark.scale.set(0.36, 0.36);
			watermark.updateHitbox();
			watermark.setPosition(FlxG.width - watermark.width - 10, FlxG.height - watermark.height + 6);
		case "ibis2":
			watermark.loadGraphic(Paths.image("game/watermarks/ibisPaint"));
			watermark.scale.set(0.36, 0.36);
			watermark.updateHitbox();
			watermark.setPosition(FlxG.width - watermark.width - 150, FlxG.height - watermark.height + 6);
		case "alight":
			watermark.loadGraphic(Paths.image("game/watermarks/alight_motion"));
			watermark.scale.set(0.36, 0.36);
			watermark.updateHitbox();
			watermark.screenCenter(0x01);
			watermark.y = -5;
		case "capcut":
			watermark.loadGraphic(Paths.image("game/watermarks/capcut"));
			watermark.scale.set(0.36, 0.36);
			watermark.updateHitbox();
			watermark.alpha = 0.8;
			watermark.x = 0;
			watermark.y = flip ? -8 : 720 - watermark.height + 8;
	}
	
	watermark.cameras = [watermarkCam];
	add(watermark);
}

/* HOW TO USE!!! :

function create(){
	watermarkType = "capcut"; 
	//watermark type!! currently available are: flipaclip, ibis1 (widescreen), ibis2 (squareResize), alight, capcut
	
	flip = !flip;
	//this is for if you use the capcut watermark!
}
*/