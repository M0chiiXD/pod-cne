import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

var background:FlxSprite;
var mask:FlxSprite;
var highlight:FlxSprite;
var frame:FlxSprite;
var label:FlxText;
var hasBG:Bool = false;

function makeRoundedGradient(width:Int, height:Int, colors:Array<Int>, radius:Int, angle:Int = 90):FlxSprite
{
	var source:FlxSprite = FlxGradient.createGradientFlxSprite(width, height, colors, 1, angle, true);

	var roundedMask:FlxSprite = new FlxSprite();
	roundedMask.makeGraphic(width, height, FlxColor.TRANSPARENT, true);

	FlxSpriteUtil.drawRoundRectComplex(roundedMask, 0, 0, width, height, radius, radius, radius, radius, FlxColor.WHITE, null, {smoothing: true});

	var result:FlxSprite = new FlxSprite();
	result.makeGraphic(width, height, FlxColor.TRANSPARENT, true);

	FlxSpriteUtil.alphaMaskFlxSprite(source, roundedMask, result);

	source.destroy();
	roundedMask.destroy();

	return result;
}

function create()
{
	FlxG.mouse.visible = true;
	FlxG.camera.bgColor = 0xFFB9A7A7;
	var x:Int = 100;
	var y:Int = 80;
	var width:Int = 100;
	var height:Int = 30;
	var radius:Int = 12;
	if (hasBG)
	{
		background = makeRoundedGradient(width, height,[/*0xDD9DC9EA, 0xCC6398C0, 0xCC31526E*/0xddd2dee8, 0xCCB7BEC3, 0xCC576169], radius, 90);
		background.x = x;
		background.y = y;
		add(background);
	}

	highlight = new FlxSprite(x, y);
	highlight.makeGraphic(width, height, FlxColor.TRANSPARENT, true);

	FlxSpriteUtil.drawRoundRectComplex(highlight, 2, 2, width - 4, Std.int(height * 0.45), radius - 2, radius - 2, radius - 2, radius - 2, 0x38FFFFFF, null, {smoothing: true});

	add(highlight);

	frame = new FlxSprite(x, y);
	frame.makeGraphic(width, height, FlxColor.TRANSPARENT, true);
	FlxSpriteUtil.drawRoundRectComplex(frame, 0, 0, width, height, radius, radius, radius, radius, FlxColor.TRANSPARENT, {color: 0xA9FDFDFD, thickness: 3}, {smoothing: true});

	add(frame);

	label = new FlxText(x, y, width, "File");
	label.setFormat("Segoe UI", 18, FlxColor.WHITE, "center");
	add(label);
}

var colorHover:Int = 0xFF00D2ED;
function update(elapsed:Float)
{
	if (FlxG.mouse.overlaps(highlight))
	{
		colorHover = 0xFF00D2ED;
	}
	else
	{
		colorHover = 0xFFFFFFFF;
	}

	if (background != null && colorHover != background.color) background.color = colorHover;
	if (background == null)
	{
		var alphaTarget:Float = FlxG.mouse.overlaps(highlight) ? 1.0 : 0.0;
		highlight.alpha += (alphaTarget - highlight.alpha) * (elapsed * 60) * 0.15;
		frame.alpha += (alphaTarget - frame.alpha) * (elapsed * 60) * 0.15;
	}
}
