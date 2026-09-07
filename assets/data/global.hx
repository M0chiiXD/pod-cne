import sys.io.File;
import hxvlc.util.Handle;
import lime.graphics.Image;
import funkin.backend.utils.WindowUtils;
import funkin.menus.credits.CreditsMain;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.ModsFolder;
import funkin.backend.system.framerate.Framerate;
import funkin.editors.EditorPicker;
import AspectUtil;
import VideoUtil;

static var AspectUtil = new AspectUtil();
static var VideoUtil = new VideoUtil();

importScript('data/scripts/genericFPSCounter');

function new() {
    FlxG.save.data.camStable ??= false;
	
	// init hxvlc handle
	try {
		import hxvlc.util.Handle;
		Handle.init([]);
	} catch(e:Any) { trace(e); }
}

function postStateSwitch(){
    if(Std.isOfType(FlxG.state, PlayState)) {
		window.title += ' - ' + PlayState.SONG.meta.displayName;
		if (PlayState.difficulty == "evil") window.title += " (Evil)";
	} else { 
		FlxG.camera.bgColor = FlxColor.BLACK;
	}
}

function update(elapsed:Float):Void {
	// thank u inferno :D
	// this is kinda bugged but its fine lmao
    if (FlxG.keys.justPressed.F11){
        FlxG.fullscreen = !FlxG.fullscreen;
    }
}

function postGameStart()
    FlxG.game._requestedState = new ModState('PODWarningState');
