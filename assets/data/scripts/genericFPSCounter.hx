// special thanks to swordcube, bobbyDX, and Anti for figuring out the systems
// special thanks to Vortex for the original processing NDLL, and Zoro for the vRAM tracking
// full FPS script built by m0chimyra (@myrasukiii_)

//im leaving these imports unchanged because im too laxy to clean ts </3
import Sys;
import Type;

import Main;

import haxe.Timer;

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

var genericFPS:TextField;
var underlay:Sprite;
var fpsNum;

var curGCMemory:Float = 0;
var maxGCMemory:Float = 0;
var curTaskMemory:Float = 0;
var maxTaskMemory:Float = 0;

var fpsUpdateTimer:Float = 999999;

// SET TO FALSE IF YOU WANT TO TRACK GC MEMORY INSTEAD!!
var trackTaskMem:Bool = true;

//CHANGE TO FALSE IF YOU'RE USING A CUSTOM FONT!
var useDefaultFont:Bool = true;
var defaultFont = Framerate.fontName;

// CHANGE THIS TO YOUR CUSTOM FONT NAME!!
var customFont = Paths.font("SourceCodePro.ttf");

var hideCounter:Bool = false;
var showDebug:Bool = false;

function new() {
	underlay = new Sprite();
	underlayDos = new Sprite();

	for (underlays in [underlay, underlayDos]) {
		underlays.graphics.beginFill(underlay ? FlxColor.BLACK : FlxColor.WHITE);
		underlays.graphics.drawRect(0, 0, 100, 100);
		underlays.graphics.endFill();
		underlays.alpha = underlay ? 0.25 : 0.3;
		Main.instance.addChild(underlays);
	}

	underlay.x = 5;

    fpsText = new TextField();
	fpsLabel = new TextField();

	for (texts in [fpsText, fpsLabel]) {
		texts.autoSize = 1;
		texts.text = "FPS";
		texts.defaultTextFormat = new TextFormat(useDefaultFont ? defaultFont : Paths.getFontName(customFont), texts == fpsText ? 17.5 : 11.5, -1);
		texts.selectable = false;
		Main.instance.addChild(texts);
	}

	debugTxt = new TextField();
	debugTxt.text = "FPS COUNTER BROKEN :/";
	debugTxt.autoSize = 1;
	debugTxt.defaultTextFormat = new TextFormat(useDefaultFont ? defaultFont : Paths.getFontName(customFont), 14.5, -1);
	debugTxt.setTextFormat(debugTxt.defaultTextFormat);
	Main.instance.addChild(debugTxt);

	Framerate.instance.visible = false;
}

var currentDebug:Int = 0;
function postUpdate(elapsed:Float) {
	Framerate.instance.alpha = 1;
	Framerate.instance.visible = false;

	trackTaskMem = !Options.useGCMemory;
	hideCounter = Options.hideFPSCounter;

    fpsNum = Framerate.fpsCounter.fpsNum.text;
	if(FlxG.keys.justPressed.F3) debugSwitch();

	curGCMemory = MemoryUtil.currentMemUsage();
	curTaskMemory = MemoryUtil.currentProcessMemUsage();
	if (curGCMemory > maxGCMemory) maxGCMemory = curGCMemory;			
	if (curTaskMemory > maxTaskMemory) maxTaskMemory = curTaskMemory;
	
	var fps:String = "";
	var text:String = "";
	
	fps = fpsNum;

	for (obj in [fpsText, fpsLabel, underlay, underlayDos]) obj.visible = !hideCounter;
	if (hideCounter) text = "";
	else updateTextStuffs();
	
	if (!showDebug && !hideCounter){
		text = trackTaskMem ? ("Task: " + formatByte(curTaskMemory)) : ("GC: " + formatByte(curGCMemory));
		fpsLabel.text = "FPS";
		underlay.visible = underlayDos.visible = true;
	} else if (showDebug && !hideCounter) {
		var objCount:Int = 0;
		var state:FlxState = FlxG.state;
		while(state != null) {
			state.forEach((o) -> { objCount++; }, true);
			state = state.subState;
		}
		var vRAMUsage =
		formatByte(FlxG.stage.context3D.gl.getParameter(openfl.display3D.Context3D.__glMemoryCurrentAvailable))
		+ " / " +
		formatByte(FlxG.stage.context3D.gl.getParameter(openfl.display3D.Context3D.__glMemoryTotalAvailable));
		var bitmapCount:Int = 0;
		for(_ in FlxG.bitmap._cache.keys()) bitmapCount++;

		text = "Memory Info:";
		text += "\n• GC: " + formatByte(curGCMemory) + " / " + formatByte(maxGCMemory);
		text += "\n• Task: " + formatByte(curTaskMemory) + " / " +  formatByte(maxTaskMemory);
		text += "\n• vRAM: " + vRAMUsage;
		text += "\n\nBuild Info:";
		text += "\n• Version: V" + Flags.VERSION;
		text += "\n• Commit Hash: " + Flags.COMMIT_HASH.toLowerCase();
		text += "\n\nState Info:";
		text += "\n• " + getStateInfo("State");
		text += "\n• " + getStateInfo("SubState");
		text += "\n\nFlixel Info:";
		text += "\n• Total Objects: " + objCount;
		text += '\n• Cached Bitmaps: ${bitmapCount}';
		text += '\n• Cached Sounds: ${FlxG.sound.list.length} \n• FlxGame Child Count: ${FlxG.game.numChildren}';
		text += "\n• Camera Count: " + FlxG.cameras.list.length;
		text += "\n\nConductor Info:";
		text += "\n• BPM: " + Conductor.bpm + " | Time Signature: " + Conductor.beatsPerMeasure + "/" + Conductor.stepsPerBeat;
		text += "\n• Step: " + Conductor.curStep + " | Beat: " + Conductor.curBeat + " | Section: " + Conductor.curMeasure;
		text += "\n\nSystem Info:";
		text += "\n• System: " + Capabilities.os;
	}

	fpsText.text = fps;
	debugTxt.text = text;
}

function debugSwitch() if (!hideCounter) showDebug = !showDebug;

function setUnderlaySize(width, height) {
    underlay.graphics.clear();
    underlay.graphics.beginFill(FlxColor.BLACK);
    underlay.graphics.drawRect(0, 0, width, height);
    underlay.graphics.endFill();

	underlayDos.graphics.clear();
	underlayDos.graphics.beginFill(FlxColor.BLACK);
	underlayDos.graphics.drawRect(0, 0, width + 4, height + 4);
	underlayDos.graphics.endFill();
	underlayDos.x = underlay.x - 2;
	underlayDos.y = underlay.y - 2;
}

function updateTextStuffs() {
	for (things in [fpsText, fpsLabel, debugTxt]) {
		things.y = Framerate.instance.y +
			switch (things) {
				case fpsText: 8;
				case fpsLabel: 14;
				case debugTxt: 30;
			};

		things.x = 7;
		setUnderlaySize(things.width + 10, fpsText.height + debugTxt.height + 10);
	}
	fpsLabel.x = fpsText.x + fpsText.width;
	underlay.y = fpsText.y - 5;
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
	for (objects in [fpsText, fpsLabel, debugTxt, underlay, underlayDos]) Main.instance.removeChild(objects);
	Framerate.instance.visible = true;
}
