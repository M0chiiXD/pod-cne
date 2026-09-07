// made by m0chimyra <3
package curtainsOS.windows;

import flixel.math.FlxRect;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

class OSButton extends FlxSprite {
    public var buttonInstance:FlxSpriteGroup = new FlxSpriteGroup();

    public var width:Float = 100;
    public var height:Float = 30;
    public var radius:Float = 4;

    public var label:String = "X";
    public var staticColor(0xFFFFFFFF, set):FlxColor;
    public var hoverColor(0xFF00D2ED, set):FlxColor;

    override public function new(x:Float = 0, y:Float = 0, width:Float, height:Float) {
        super(x, y);

        background = makeRoundedGradient(width, height,[0xddd2dee8, 0xCCB7BEC3, 0xCC576169], radius);
        background.setPosition();
        buttonInstance.add(background);

        highlight = new FlxSprite(0, 0);
        highlight.makeGraphic(width, height, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRectComplex(highlight, 2, 2, width - 4, Std.int(height * 0.45), radius - 2, radius - 2, radius - 2, radius - 2, 0x38FFFFFF, null, {smoothing: true});
        buttonInstance.add(highlight);

        var frame = new FlxSprite();
        frame.makeGraphic(width, height, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRectComplex(frame, 0, 0, width, height, radius, radius, radius, radius, FlxColor.TRANSPARENT, {color: 0xA9FDFDFD, thickness: 3}, {smoothing: true});
        buttonInstance.add(frame);

        label = new FlxText(0, 0, width, label);
        label.setFormat("Segoe UI", 12, FlxColor.WHITE, "center");
        buttonInstance.add(label);

        buttonInstance.setPosition(x, y);
        setPosition(x, y);
    }

    function makeRoundedGradient(width:Float, height:Float, colors:Array<Float>, radius:Float, ?angle:Float = 90) {
        var source:FlxSprite = FlxGradient.createGradientFlxSprite(width, height, colors, 1, angle, true);
        var roundedMask:FlxSprite = new FlxSprite(0, 0).makeGraphic(width, height, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRectComplex(roundedMask, 0, 0, width, height, radius, radius, radius, radius, FlxColor.WHITE, null, {smoothing: true});
    }

    var colorHover;
    public override function postUpdate(elapsed:Float) {
        if (FlxG.mouse.overlaps(background)) {
            colorHover = hoverColor;
        } else{
            colorHover = staticColor;
        }

        if (background != null && colorHover != background.color) background.color = colorHover;
        if (background == null) {
            var alphaTarget:Float = FlxG.mouse.overlaps(highlight) ? 1.0 : 0.3;
            highlight.alpha = lerp(highlight.alpha, (alphaTarget - highlight.alpha), 0.25);
            frame.alpha = lerp(frame.alpha, (alphaTarget - frame.alpha), 0.25);
        }
    }

    public static function set_staticCover(c:FlxColor) {
        staticColor = c;
    }

    public static  function set_hoverCover(c:FlxColor) {
        hoverColor = c;
    }

    public static  function set_label(c:String) {
        label = c;
    }

    public override function draw():Void { buttonInstance.draw(); }
}
