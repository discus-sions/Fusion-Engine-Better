package;

import flixel.FlxSprite;
import flixel.FlxG;

#if windows
import Sys;
import sys.FileSystem;
#end

#if sys
import sys.io.File;
import haxe.io.Path;
import openfl.utils.ByteArray;
import flash.display.BitmapData;
import sys.FileSystem;
#end

using StringTools;

enum abstract IconState(Int) from Int to Int {
	var Normal;
	var Dying;
	var Poisoned;
	var Winning;
}

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var iconState(default, set):IconState = Normal;
	function set_iconState(x:IconState):IconState {
		switch (x) {
			case Normal:
				animation.curAnim.curFrame = 0;
			case Dying:
				// if we set it out of bounds it doesn't realy matter as it goes to normal anyway
				animation.curAnim.curFrame = 1;
			case Poisoned:
				// same deal it will go to dying which is good enough
				animation.curAnim.curFrame = 2;
			case Winning:
				// we DO do it here here we want to make sure it isn't silly
				if (animation.curAnim.frames.length >= 4) {
					animation.curAnim.curFrame = 3;
				} else {
					animation.curAnim.curFrame = 0;
				}
		}
		return iconState = x;
	}

	public function switchAnim(char:String = 'bf') {
		var charJson:Dynamic = CoolUtil.parseJson(File.getContent("assets/images/custom_chars/custom_chars.jsonc"));
		var iconJson:Dynamic = CoolUtil.parseJson(File.getContent("assets/images/custom_chars/icon_only_chars.json"));
		var iconFrames:Array<Int> = [];
		if (Reflect.hasField(charJson, char))
		{
			iconFrames = Reflect.field(charJson, char).icons;
		}
		else if (Reflect.hasField(iconJson, char))
		{
			iconFrames = Reflect.field(iconJson, char).frames;
		}
		else
		{
			iconFrames = [0, 0, 0, 0];
		}

		if (FileSystem.exists('assets/images/custom_chars/' + char + "/icons.png"))
		{
			var rawPic:BitmapData = BitmapData.fromFile('assets/images/custom_chars/' + char + "/icons.png");
			loadGraphic(rawPic, true, 150, 150);
			animation.add('icon', iconFrames, false, isPlayer);
		}
		else
		{
			loadGraphic('assets/images/iconGrid.png', true, 150, 150);
			animation.add('icon', iconFrames, false, isPlayer);
		}
		animation.play('icon');
		animation.pause();
	}

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		this.isPlayer = isPlayer;
		super();
		antialiasing = true;
		checkIcon(char, isPlayer);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var notThere:Bool = false;

			var name:String = 'betterfusion_customize/icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'betterfusion_customize/icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) notThere = true;
			trace('images/' + name + '.png');
			if (!notThere) {
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;
			updateHitbox();

			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = FlxG.save.data.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
			} else {
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [10, 11], 0, false, isPlayer);
				animation.play('icon');
				scrollFactor.set();
			}
		}
	}
	public function changeFusionIcon(char:String, isPlayer:Bool = false) {
		#if sys
			var charJson:Dynamic = CoolUtil.parseJson(File.getContent("assets/images/custom_chars/custom_chars.jsonc"));
			#end
			antialiasing = true;
			switch (char) {
				case 'bf':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [0, 1, 24], 0, false, isPlayer);
	
				case 'bf-car':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [0, 1,24], 0, false, isPlayer);
				case 'bf-christmas':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [0, 1,24], 0, false, isPlayer);
				case 'spooky':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [2, 3], 0, false, isPlayer);
				case 'pico':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [4, 5], 0, false, isPlayer);
				case 'mom':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [6, 7], 0, false, isPlayer);
				case 'mom-car':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [6, 7], 0, false, isPlayer);
				case 'tankman':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [8, 9], 0, false, isPlayer);
				case 'face':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [10, 11], 0, false, isPlayer);
				case 'dad':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [12, 13], 0, false, isPlayer);
				case 'bf-old':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [14, 15], 0, false, isPlayer);
				case 'gf':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [16, 16], 0, false, isPlayer);
				case 'parents-christmas':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [17,17], 0, false, isPlayer);
				case 'monster':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [19, 20], 0, false, isPlayer);
				case 'monster-christmas':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [19, 20], 0, false, isPlayer);
				case 'senpai':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [22, 22], 0, false, isPlayer);
				case 'senpai-angry':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [22, 22], 0, false, isPlayer);
				case 'spirit':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [23, 23], 0, false, isPlayer);
				case 'bf-pixel':
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', [21, 21, 25], 0, false, isPlayer);
				default:
					// check if there is an icon file
					if (FileSystem.exists('assets/images/custom_chars/'+char+"/icons.png")) {
						var rawPic:BitmapData = BitmapData.fromFile('assets/images/custom_chars/'+char+"/icons.png");
						loadGraphic(rawPic, true, 150, 150);
						animation.add('icon', Reflect.field(charJson,char).icons, false, isPlayer);
					} else {
						trace("ok so we here");
						loadGraphic('assets/images/iconGrid.png', true, 150, 150);
						animation.add('icon', Reflect.field(charJson,char).icons, false, isPlayer);
					}
			}
			animation.play('icon');
			scrollFactor.set();
	}

	public function checkIcon(char:String = 'bf', isPlayer:Bool = false)
	{
		if(FileSystem.exists('assets/images/betterfusion_customize/icons/' + char + '.png'))
		{ //later versions of psych icon support
			changeIcon(char);
		}
		else if(FileSystem.exists('assets/images/betterfusion_customize/icons/icon-' + char + '.png'))
		{ //older versions of psych icon support
			changeIcon(char);
		}
		else 
		{
		//	changeFusionIcon(char, isPlayer);
			switchAnim(char);
		}
	}
}
