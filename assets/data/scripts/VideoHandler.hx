// forked from gorefield, reworked by m0chimyra <3

import hxvlc.openfl.Video;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;

function onSubstateOpen(event) if (VideoHandler.curVideo != null && paused) VideoHandler.curVideo.pause();

function onSubstateClose(event) if (VideoHandler.curVideo != null && paused) VideoHandler.curVideo.resume();

function focusGained() if (VideoHandler.curVideo != null && !paused) VideoHandler.curVideo.resume();

public var camVideos:FlxCamera;

public var VideoHandler:T = {
	curVideo: null,
	videoList: [],
	load: function(paths:Array<String>, ?scaleMult:Int, ?onEndReached:Void->Void) {
		var _onEndReached:String->Void = onEndReached;
		
		if (scaleMult == null) scaleMult = 0;
		else scaleMult = scaleMult;
		
		camVideos = new FlxCamera();
        camVideos.bgColor = FlxColor.BLACK;
        camVideos.visible = false;
		FlxG.cameras.add(camVideos, false);
		
		var prevAutoPause:Bool = FlxG.autoPause;
        FlxG.autoPause = false;
		
		for (vid in paths) {
			video = new FlxVideoSprite();
			video.camera = camVideos;
			video.bitmap.onFormatSetup.add(function() {
				if (video.bitmap != null && video.bitmap.bitmapData != null) {
					video.setGraphicSize(FlxG.width * scaleMult, FlxG.height);
					video.updateHitbox();
					video.screenCenter();
				}
			});
			
			VideoHandler.videoList.push(video);
			
			video.bitmap.onEndReached.add(function() {
				VideoHandler.curVideo.bitmap.dispose();
                remove(VideoHandler.curVideo);
				
				VideoHandler.videoList.shift();
                VideoHandler.curVideo = null;
				
				camVideos.visible = false;
				
                if (_onEndReached != null)
                    _onEndReached();
            });
			
			if (video.load(Assets.getPath(Paths.video(vid)), [':no-audio'])) {
				video.play();
				video.pause();
				video?.bitmap?.time = 0;
				trace("Loaded Video: " + vid);
			}
		}
		FlxG.autoPause = prevAutoPause;
		if (FlxG.autoPause) {
			for (video in VideoHandler.videoList)
				if (!FlxG.signals.focusLost.has(video.pause))
					FlxG.signals.focusLost.add(video.pause);
				
			if (!FlxG.signals.focusGained.has(focusGained))
				FlxG.signals.focusGained.add(focusGained);
		}
	},
	playNext: function() {
		VideoHandler.curVideo = VideoHandler.videoList[0];
		VideoHandler.curVideo.play();
		camVideos.visible = true;
		add(VideoHandler.curVideo);
	},
	destroyCur: function() {
		VideoHandler.curVideo.bitmap.dispose();
		remove(VideoHandler.curVideo);
		VideoHandler.videoList.shift();
		VideoHandler.curVideo = null;
		camVideos.visible = false;
	}
}

function postCreate() {
	if (VideoHandler.videoList.length >= 0){
		for (i in VideoHandler.videoList) i.bitmap.onFormatSetup.add(function()
			{
				i.scale.set(1.5, 1.5);
				i.updateHitbox();
				i.screenCenter();
			});
	}
}

function destroy() {
	for (i in VideoHandler.videoList) {
		i.bitmap.dispose();
		remove(i);
	}
}