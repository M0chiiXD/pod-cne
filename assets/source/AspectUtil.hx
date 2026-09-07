import StringTools;
import openfl.Lib;
import openfl.system.Capabilities;
import lime.graphics.Image;
import funkin.backend.utils.WindowUtils;
import openfl.geom.ColorTransform;

class AspectUtil {
    static var _instance:AspectUtil;
	
    public function new() {
        if (_instance != null) return null;
        AspectUtil._instance = this;
    }
	
	public var width(default, set):Float = 1280;
    public var height(default, set):Float = 720;

    function set_width(v:Float):Float {
		window.resize(v, height);
		FlxG.resizeGame(v, height);
		FlxG.scaleMode.width = FlxG.camera.width = v;
		Lib.application.window.x = Std.int((Capabilities.screenResolutionX * 0.5) - (Lib.application.window.width * 0.5));
	}
	
	function set_height(v:Float):Float {
		window.resize(width, v);
		FlxG.resizeGame(width, v);
		FlxG.scaleMode.height = FlxG.camera.height = v;
		Lib.application.window.y = Std.int((Capabilities.screenResolutionY * 0.5) - (Lib.application.window.height * 0.5));
	}
	
	public function exitFullscreen() {
		window.maximized = window.fullscreen = false;
	}
	
	public function reset() {
        width = 1280;
        height = 720;
    }
}
