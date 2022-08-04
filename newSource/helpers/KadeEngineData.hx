import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;
		if (FlxG.save.data.resetKey == null)
			FlxG.save.data.resetKey = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.controls == null)
			FlxG.save.data.controls = "wasd";
			
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine
		
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.notesplash == null)
			FlxG.save.data.notesplash = true;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = true;

		if (FlxG.save.data.freeplayInst == null)
			FlxG.save.data.freeplayInst = true;

		if (FlxG.save.data.circleShit == null)
			FlxG.save.data.circleShit = false;

		if (FlxG.save.data.zoom == null)
			FlxG.save.data.zoom = 1;

		if (FlxG.save.data.noZoom == null)
			FlxG.save.data.noZoom = false;

		if (FlxG.save.data.achievements == null)
			FlxG.save.data.achievements = false;

		Conductor.recalculateTimings();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}
