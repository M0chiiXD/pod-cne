/**
	Created by ItsLJcool, Please credit if you use this :)

	GitHub: https://github.com/ItsLJcool?tab=repositories
	Ko-fi: https://ko-fi.com/itsljcool
	Discord @itsljcool
**/

import openfl.geom.ColorTransform;
import Math;

class OutlineModifier extends FlxBasic {
	public var binds:Array<FlxSprite> = [];

	// This contains *normalized points to draw the outline around the Sprite,
	public var poses:Array<FlxPoint> = [];
	
	
	// This will be the number of sprites drawn behind the Sprite. Higher = More Quality | Lower = Less Quality
	public var total(default, set):Int = 16;
	private function set_total(val:Int):Int {
		// total = Math.min(1, val);
		total = val;
		regen_outline();
	}

	// The offset / size of the outline
	public var offset:Float = 4;
	
	public var color:FlxColor;

	override public function new(sprite:FlxSprite, ?color:FlxColor) {
		super();

		this.color = (color ?? FlxColor.RED);

		bind(sprite);
		regen_outline();
	}

	override public function draw() {
		if (!this.active || !this.visible) return;

		var outlineCT:ColorTransform = new ColorTransform();
		outlineCT.color = this.color;

		for (obj in this.binds) {
			var oldColor = obj.colorTransform;
			obj.colorTransform = outlineCT;

			for (point in this.poses) {
				var x = point.x * this.offset;
				var y = point.y * this.offset;
				obj.x += x; obj.y += y;
				obj.draw();
				obj.x -= x; obj.y -= y;
			}
			obj.colorTransform = oldColor;
		}
	}

	public function bind(sprite:FlxSprite) {
		binds.push(sprite);
	}

	public function regen_outline() {
		var angleOff = 360 / this.total;
		var TO_RAD = Math.PI / 180;

		for (point in this.poses) point.put();
		CoolUtil.clear(this.poses);

		for (i in 0...total) {
			var angle = angleOff * i * TO_RAD;
			this.poses.push(FlxPoint.get(Math.sin(angle), Math.cos(angle)));
		}
	}
}
