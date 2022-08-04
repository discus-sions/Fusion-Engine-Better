package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

// TAKEN FROM EXTRA KEYS. THANNKS ZORO

using StringTools;

class NoteSplash extends FlxSprite
{

	public static var colors:Array<String> = ['purple', 'blue', 'green', 'red'];

	var colorsThatDontChange:Array<String> = ['purple', 'blue', 'green', 'red'];

	var randos:Int = FlxG.random.int(-2, 2); //fuck this

	var SplashFrameRate:Int = 24 + FlxG.random.int(-2, 2);

	public function new(nX:Float, nY:Float, color:Int)
	{
		x = nX;
		y = nY;
		super(x, y);
		frames = Paths.getSparrowAtlas('noteassets/notesplash/Splash');
		for (i in 0...colorsThatDontChange.length)
		{
			animation.addByPrefix(colorsThatDontChange[i] + ' splash', "splash " + colorsThatDontChange[i], 24, false);
		}
		//animation.play('splash');
		antialiasing = true;
		updateHitbox();
		makeSplash(nX, nY, color);
	}

	public function makeSplash(nX:Float, nY:Float, color:Int) 
	{
        setPosition(nX - 105, nY - 110);
		angle = FlxG.random.int(0, 360);
        alpha = 0.6;
        animation.play(colors[color] + ' splash', true);
		animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
		//offset.set(500, 200);
        this.updateHitbox();   
    }

	override public function update(elapsed) 
	{
        if (animation.curAnim.finished)
		{
            kill();
        }
        super.update(elapsed);
    }
}