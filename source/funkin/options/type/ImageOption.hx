package funkin.options.type;

import flixel.util.FlxColor;

/**
 * Option type that has image and text. Used for POD's Base Options Menu.
 **/
class ImageOption extends TextOption {
	public var imgSpr:FlxSprite;

	public function new(name:String, desc:String, icon:String, ?suffix:String = "", callback:Void->Void) {
		super(name, desc, callback);
		itemHeight = 150;

		__text.x = 100;

		imgSpr = new FlxSprite().loadGraphic(Paths.image("menus/options/optionIcons/" + icon));
		imgSpr.setPosition(90 - imgSpr.width, (__text.height - imgSpr.height) / 2);
		imgSpr.scale.set(1.4, 1.4);
		imgSpr.updateHitbox();
		imgSpr.offset.set(15, -15);
		add(imgSpr);
	}
}
