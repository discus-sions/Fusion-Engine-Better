package;

import flixel.FlxSprite;
import flixel.FlxG;
import flash.display.BitmapData;

#if sys
import sys.io.File;
import haxe.io.Path;
import openfl.utils.ByteArray;
import sys.FileSystem;
#end

using StringTools;

class AttachedSprite extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var xAdd:Float = 0;
	public var yAdd:Float = 0;
	public var angleAdd:Float = 0;
	public var alphaAdd:Float = 0;

	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;
	public var copyVisible:Bool = false;

	public function new(file:String, ?anim:String = null, ?library:String = null, ?loop:Bool = false)
	{
		super();
		if(anim != null) {
			frames = Paths.getSparrowAtlas(file, library);
			animation.addByPrefix('idle', anim, 24, loop);
			animation.play('idle');
		} else {
			loadGraphic(BitmapData.fromFile(Paths.image(file)));
		}
		antialiasing = FlxG.save.data.antialiasing;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + xAdd, sprTracker.y + yAdd);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);

			if(copyAngle)
				angle = sprTracker.angle + angleAdd;

			if(copyAlpha)
				alpha = sprTracker.alpha + alphaAdd;

			if(copyVisible) 
				visible = sprTracker.visible;
		}
	}
}
