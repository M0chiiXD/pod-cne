// made by m0chimyra <3
package curtainsOS.windows;

import curtainsOS.OSButton;
import curtainsOS.BitmapDataUtil;
import openfl.geom.Rectangle;

import flixel.math.FlxRect;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxDestroyUtil;

class BasicWindow extends FlxSprite {
	public var windowInstance:FlxSpriteGroup = new FlxSpriteGroup();

	public var x:Float;
	public var y:Float;

	public var width:Float;
	public var height:Float;

	public var draggable:Bool = true;

	public var title:String;
	public var radius:Float = 6;
	public var borderColor:FlxColor = FlxColor.GRAY;
	public var winHBox;
	public var closeWin;
	public var instance:FlxState;
	public var windowBase:FlxSprite;
	public var windowTitle:FunkinText;
	public var windowContent:FlxCamera;

	public function new(x:Float, y:Float, width:Float = 864, height:Float = 490, ?name:String) {
		super();

		this.instance = instance;

		if (name != null) title = name; else title = "Test";

		winHBox = new FlxSprite().makeGraphic(width, height * 0.05, FlxColor.TRANSPARENT);

		maskBase = new FlxSprite().makeGraphic(width, height, FlxColor.TRANSPARENT, true);
		FlxSpriteUtil.drawRoundRectComplex(maskBase, 0, 0, width, height, radius, radius, radius, radius, borderColor, null, {smoothing: true});

		windowBase = new FlxSprite(5, 30).makeGraphic(width - 10, height - 35, FlxColor.WHITE, true);

		windowTitle = new FunkinText(25, 0, maskBase.width, title, 18).setFormat(Paths.font("Segoe/Segoe UI.ttf"), 20, FlxColor.WHITE, "left");

	//	closeWin = new OSButton(x, y, 30, 20);

		windowInstance.add(maskBase);
		windowInstance.add(windowBase);
		windowInstance.add(windowTitle);
		windowInstance.add(winHBox);
	//	windowInstance.add(closeWin);
		windowInstance.setPosition(x, y);

		/*windowContent = new FlxCamera(0, 0, width - 10, height - 35);
		windowContent.bgColor = FlxColor.RED;
		windowContent.alpha = 0.5;
		FlxG.cameras.add(windowContent, false);*/

//		closeWin = new FlxSprite(30, 35).makeGraphic(20, 20, FlxColor.RED).cameras = windowContent;
//		add(closeWin); setPosition(FlxG.mouse.x - dragOffset.x, FlxG.mouse.y - dragOffset.y);
	}

	function update(elapsed:Float):Void {
		// since im extending FlxSprite, i have to set the values myself manually T^T
		windowInstance.scale.set(scale.x, scale.y);
		windowInstance.alpha = alpha;

		var startMousePos:FlxPoint = new FlxPoint();
		var startComboOffset:FlxPoint = new FlxPoint();

		// window logic
		var dragWindow:Bool = false;

		if (FlxG.mouse.overlaps(winHBox) && FlxG.mouse.pressed) {
			if (draggable) {
				dragWindow = true;
			}
		}

		if (dragWindow) {
			var dragX = Math.round((FlxG.mouse.deltaScreenX - startMousePos.x) + windowInstance.x);
			var dragY = Math.round((FlxG.mouse.deltaScreenY- startMousePos.y) + windowInstance.y);
			windowInstance.setPosition(dragX, dragY);
		}
	}

	public override function draw():Void { windowInstance.draw(); }

	override function destroy():Void {
		FlxDestroyUtil.destroy(windowInstance);
		super.destroy();
	}
}
