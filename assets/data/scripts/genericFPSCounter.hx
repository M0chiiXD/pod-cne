// special thanks to swordcube, bobbyDX, and Anti for figuring out the systems
// special thanks to Vortex for the processing NDLL, and Zoro for the vRAM tracking
// full FPS script built by m0chimyra <3

import Sys;
import Type;

import Main;

import haxe.Timer;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSubState;
import flixel.util.FlxStringUtil;

import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.Capabilities;
import openfl.events.Event;

import funkin.backend.assets.ModsFolder;
import funkin.backend.system.Main;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.framerate.SystemInfo;
import funkin.backend.utils.MemoryUtil;
import funkin.backend.utils.WindowUtils;
import funkin.backend.utils.NdllUtil;

var genericFPS:TextField;
var underlay:Sprite;
var fpsNum;

var curGCMemory:Float = 0;
var maxGCMemory:Float = 0;
var curTaskMemory:Float = 0;
var maxTaskMemory:Float = 0;

var fpsUpdateTimer:Float = 999999;

//CHANGE TO FALSE IF YOU'RE USING A CUSTOM FONT!
var useDefaultFont:Bool = true;
var defaultFont = Framerate.fontName;
var currentDebug:Int = 0;

// CHANGE THIS TO YOUR CUSTOM FONT NAME!!
var customFont = Paths.getFontName("SourceCodePro.ttf");

function new() {
    underlay = new Sprite();
	underlay.graphics.beginFill(FlxColor.BLACK);
    underlay.graphics.drawRect(0, 0, 100, 100);
    underlay.graphics.endFill();
    underlay.alpha = 0.555;
    underlay.x = 5;
    underlay.y = 9;
    Main.instance.addChild(underlay);
	
	var format:TextFormat = new TextFormat(useDefaultFont ? defaultFont : customFont, 15, 0xFFFFFFFF);

    genericFPS = new TextField();
    genericFPS.x = 6;
    genericFPS.y = 10;
    genericFPS.text = "FPS COUNTER BROKEN :/";
    genericFPS.autoSize = 1;
    genericFPS.defaultTextFormat = format;
	genericFPS.setTextFormat(genericFPS.defaultTextFormat);
    Main.instance.addChild(genericFPS);
}

var taskMem = NdllUtil.getFunction("processinfo", "processinfo_get_memory_usage", 0);

function update(elapsed:Float) {
    fpsNum = Framerate.fpsCounter.fpsNum.text;
	if(FlxG.keys.justPressed.F3) swapDebugCase(1);
	
	Framerate.instance.visible = false;

	curGCMemory = Framerate.memoryCounter.memory;
	curTaskMemory = taskMem();
	if (curGCMemory > maxGCMemory) maxGCMemory = curGCMemory;			
	if (curTaskMemory > maxTaskMemory) maxTaskMemory = curTaskMemory;
	
	var text:String = "";
	
	if (currentDebug == 0){
		text = "FPS: " + fpsNum + " • Memory: " + formatByte(curGCMemory) + " / " +  formatByte(maxGCMemory);
		underlay.visible = true;
	} else if (currentDebug == 1) {
		var objCount:Int = 0;
		var state:FlxState = FlxG.state;
		while(state != null) { 
			state.forEach((o) -> { objCount++; }, true);
			state = state.subState;
		}
			
		var vRAMUsage = 
		FlxStringUtil.formatBytes(FlxG.stage.context3D.gl.getParameter(openfl.display3D.Context3D.__glMemoryCurrentAvailable)) 
		+ " / " + 
		FlxStringUtil.formatBytes(FlxG.stage.context3D.gl.getParameter(openfl.display3D.Context3D.__glMemoryTotalAvailable));
			
		var bitmapCount:Int = 0;
		for(_ in FlxG.bitmap._cache.keys()) bitmapCount++;
			
		text = "FPS: " + fpsNum;
		text += "\nGC MEM: " + formatByte(curGCMemory) + " / " + formatByte(maxGCMemory);
		text += "\nTask MEM: " + formatByte(curTaskMemory) + " / " +  formatByte(maxTaskMemory);
		text += "\nvRAM Usage: " + vRAMUsage;
		text += "\n\n<---Mod Info--->";
		text += "\nMod Name: " + if (Flags.MOD_NAME == "") "None" else Flags.MOD_NAME;
		text += "\nMod Author: " + if (Flags.MOD_AUTHOR == "") "None" else Flags.MOD_AUTHOR;
		text += "\n\n<---Build Info--->";
		text += "\nBuild Num: " + Flags.VERSION;
		text += "\nCommit Hash: " + Flags.COMMIT_HASH.toLowerCase();
		text += "\n\n<---Flixel Info--->";
		text += "\n" + getStateInfo("State");
		text += "\n" + getStateInfo("SubState");
		text += "\nTotal Objects: " + objCount;
		text += '\nCached Bitmaps: ${bitmapCount}';
		text += '\nCached Sounds: ${FlxG.sound.list.length} \nFlxGame Child Count: ${FlxG.game.numChildren}';
		text += "\nCamera Count: " + FlxG.cameras.list.length;
		text += "\n\n<---Conductor Info--->";
		text += "\nBPM: " + Conductor.bpm + " • Time Signature: " + Conductor.beatsPerMeasure + "/" + Conductor.stepsPerBeat;
		text += "\nStep: " + Conductor.curStep + " • Beat: " + Conductor.curBeat + " • Section: " + Conductor.curMeasure;
		text += "\n\n<---System Info--->";
		text += "\nSystem: " + Capabilities.os;
	} else if (currentDebug == 2) {
		text = "";
		genericFPS.width = genericFPS.textWidth + 10;
		underlay.visible = false;
	}
	genericFPS.text = text;
	setUnderlaySize(genericFPS.width + 3, genericFPS.height + 2);
	underlay.y = genericFPS.y = Framerate.instance.y + 4;
}

function swapDebugCase(num:Int) currentDebug = FlxMath.wrap(currentDebug + num, 0, 2);

function setUnderlaySize(width, height) {
    underlay.graphics.clear();
    underlay.graphics.beginFill(FlxColor.BLACK);
    underlay.graphics.drawRect(0, 0, width, height);
    underlay.graphics.endFill();
}

function getStateInfo(type:String) {
	var curState = Type.getClassName(Type.getClass(FlxG.state));
	var curSubState = Type.getClassName(Type.getClass(FlxG.state.subState));
	
	switch (type) {
		case "State": 
			if (curState != null) {
				if (curState == 'funkin.backend.scripting.ModState') 
					return "ModState: " + FlxG.state.scriptName;
				else 
					return "State: " + curState ?? "None";
			} else
					return "State: None";
		case "SubState": 
			if (curSubState != null) {
				if (curSubState == 'funkin.backend.scripting.ModSubState') 
					return "ModSubState: " + FlxG.state.subState.scriptName;
				else 
					return "SubState: " + curSubState ?? "None";
			} else 
					return "SubState: None";
	}
}

function formatByte(target:Float) return CoolUtil.getSizeString(target).toUpperCase();

function destroy() {
	Main.instance.removeChild(genericFPS);
	Main.instance.removeChild(underlay);
	Framerate.instance.visible = true;
}