package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flash.display.BitmapData;
import lime.utils.Assets;
import flixel.graphics.frames.FlxFrame;
import lime.system.System;
import flixel.system.FlxAssets.FlxSoundAsset;
#if sys
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import openfl.utils.ByteArray;
import lime.media.AudioBuffer;
import flash.media.Sound;
#end
import haxe.Json;
import haxe.format.JsonParser;
import tjson.TJSON;
using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	var acceptSound:FlxSoundAsset;
	var clickSounds:Array<Null<FlxSoundAsset>> = [null, null, null];
	public var finishThing:Void->Void;
	public var like:String = "senpai";
	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitCustom:FlxSprite;
	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var isPixel:Array<Bool> = [true,true,true];
	var senpaiColor:FlxColor = FlxColor.WHITE;
	var textColor:FlxColor = 0xFF3F2021;
	var dropColor:FlxColor = 0xFFD89494;
	var rightHanded:Array<Bool> = [true, false];
	var font:String = "pixel.otf";
	var senpaiVisible = true;
	var sided:Bool = false;
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		trace('hey guys');
		clickSounds[2] = 'assets/sounds/pixelText.ogg';
		switch (PlayState.SONG.cutsceneType)
		{
			case 'senpai':
				FlxG.sound.playMusic('assets/music/Lunchbox' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'spirit':
				FlxG.sound.playMusic('assets/music/LunchboxScary' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'angry-senpai':
				// do nothing
			default:
				// see if the song has one
				if (FileSystem.exists('assets/data/'+PlayState.SONG.song.toLowerCase()+'/Lunchbox.ogg')) {
					var lunchboxSound = Sound.fromFile('assets/data/'+PlayState.SONG.song.toLowerCase()+'/Lunchbox.ogg');
					FlxG.sound.playMusic(lunchboxSound, 0);
					FlxG.sound.music.fadeIn(1,0,0.8);
				// otherwise see if there is an ogg file in the dialog
			} else if (FileSystem.exists('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/Lunchbox.ogg')) {
					var lunchboxSound = Sound.fromFile('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/Lunchbox.ogg');
					FlxG.sound.playMusic(lunchboxSound, 0);
					FlxG.sound.music.fadeIn(1,0,0.8);
				}
		}
		trace("here1");
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		acceptSound = 'assets/sound/clickText.ogg';
		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);
		trace("here2");
		portraitLeft = new FlxSprite(-20, 40);
		switch (PlayState.SONG.player2)
		{
			case 'bf' | 'bf-car':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/bfPortrait.png', 'assets/images/bfPortrait.xml');
				isPixel[1] = false;
			case 'bf-christmas':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/bfPortraitXmas.png', 'assets/images/christmas/bfPortraitXmas.xml');
				isPixel[1] = false;
			case 'pico':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/picoPortrait.png', 'assets/images/picoPortrait.xml');
				isPixel[1] = false;
			case 'spooky':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/spookyPortrait.png', 'assets/images/spookyPortrait.xml');
				isPixel[1] = false;
			case 'gf':
				// cursed
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/gfPortrait.png', 'assets/images/gfPortrait.xml');
				isPixel[1] = false;
			case 'dad':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/dadPortrait.png', 'assets/images/dadPortrait.xml');
				isPixel[1] = false;
			case 'mom' | 'mom-car':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/momPortrait.png', 'assets/images/momPortrait.xml');
				isPixel[1] = false;
			case 'parents-christmas':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/parentsPortrait.png',
					'assets/images/christmas/parentsPortrait.xml');
				isPixel[1] = false;
			case 'monster-christmas':
				// haha santa hat
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/monsterXmasPortrait.png',
					'assets/images/christmas/monsterXmasPortrait.xml');
				isPixel[1] = false;
			case 'monster':
				portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/monsterPortrait.png', 'assets/images/monsterPortrait.xml');
				isPixel[1] = false;
			default:
				if (FileSystem.exists('assets/images/custom_chars/' + PlayState.SONG.player2 + '/portrait.png'))
				{
					var coolP2Json = Character.getAnimJson(PlayState.SONG.player2);
					isPixel[1] = if (Reflect.hasField(coolP2Json, "isPixel")) coolP2Json.isPixel else false;
					var rawPic = BitmapData.fromFile('assets/images/custom_chars/' + PlayState.SONG.player2 + "/portrait.png");
					var rawXml = File.getContent('assets/images/custom_chars/' + PlayState.SONG.player2 + "/portrait.xml");
					portraitLeft.frames = FlxAtlasFrames.fromSparrow(rawPic, rawXml);
				}
				else
				{
					portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiPortrait.png', 'assets/images/weeb/senpaiPortrait.xml');
				}
				if (FileSystem.exists('assets/images/custom_chars/' + PlayState.SONG.player2 + '/text.ogg'))
				{
					clickSounds[1] = Sound.fromFile('assets/images/custom_chars/' + PlayState.SONG.player2 + '/text.ogg');
				}
		}
		if (isPixel[1]) {
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		} else {
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
		}
		trace("here3");
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		switch (PlayState.SONG.player1) {
			case 'bf' | 'bf-car':
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/bfPortrait.png', 'assets/images/bfPortrait.xml');
				isPixel[0] = false;
			case 'bf-christmas':
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/bfPortraitXmas.png','assets/images/christmas/bfPortraitXmas.xml');
				isPixel[0] = false;
			case 'pico': 
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/picoPortrait.png','assets/images/picoPortrait.xml');
				isPixel[0] = false;
			case 'spooky':
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/spookyPortrait.png', 'assets/images/spookyPortrait.xml');
				isPixel[0] = false;
			case 'gf':
				// is this even possible? lmao weeeeee
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/gfPortrait.png', 'assets/images/gfPortrait.xml');
				isPixel[0] = false;
			case 'dad':
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/dadPortrait.png', 'assets/images/dadPortrait.xml');
				isPixel[0] = false;
			case 'mom' | 'mom-car':
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/momPortrait.png', 'assets/images/momPortrait.xml');
				isPixel[0] = false;
			case 'parents-christmas':
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/parentsPortrait.png', 'assets/images/christmas/parentsPortrait.xml');
				isPixel[0] = false;
			case 'monster-christmas':
				// haha santa hat 
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/monsterXmasPortrait.png', 'assets/images/christmas/monsterXmasPortrait.xml');
				isPixel[0] = false;
			case 'monster':
				portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/monsterPortrait.png',
					'assets/images/monsterPortrait.xml');
				isPixel[0] = false;
			default:
				if (FileSystem.exists('assets/images/custom_chars/' + PlayState.SONG.player1 + '/portrait.png'))
				{
					var coolP1Json = Character.getAnimJson(PlayState.SONG.player1);
					isPixel[0] = if (Reflect.hasField(coolP1Json, "isPixel")) coolP1Json.isPixel else false;
					var rawPic = BitmapData.fromFile('assets/images/custom_chars/' + PlayState.SONG.player1 + "/portrait.png");
					var rawXml = File.getContent('assets/images/custom_chars/' + PlayState.SONG.player1 + "/portrait.xml");
					portraitRight.frames = FlxAtlasFrames.fromSparrow(rawPic, rawXml);
				}
				else
				{
					portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
				}
				if (FileSystem.exists('assets/images/custom_chars/'+ PlayState.SONG.player1 + '/text.ogg')) {
					clickSounds[0] = Sound.fromFile('assets/images/custom_chars/' + PlayState.SONG.player1 + '/text.ogg');
				}
		}
		trace("here4");
		var gameingFrames:Array<FlxFrame> = [];
		var leftFrames:Array<FlxFrame> = [];
		trace('gay');
		for (frame in portraitRight.frames.frames)
		{
			if (frame.name != null && StringTools.startsWith(frame.name, 'Boyfriend portrait enter'))
			{
				gameingFrames.push(frame);
			}
		}
		for (frame in portraitLeft.frames.frames)
		{
			if (frame.name != null && StringTools.startsWith(frame.name, 'Boyfriend portrait enter'))
			{
				leftFrames.push(frame);
			}
		}
		if (gameingFrames.length == 0) {
			rightHanded[0] = false;
		}
		if (leftFrames.length > 0) {
			rightHanded[1] = true;
		}
		trace(rightHanded[0] + ' ' + rightHanded[1]);
		if (rightHanded[0]) {
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		} else {
			portraitRight.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitRight.flipX = true;
		}
		if (!rightHanded[1]) {
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		} else {
			portraitLeft.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitLeft.flipX = true;
		}
		// allow player to use non pixel portraits. this means the image size can be around 6 times the size, based on the pixel zoom
		if (isPixel[0]) {
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		} else {
			portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
		}
		trace("here5");
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box = new FlxSprite(-20, 45);

		switch (PlayState.SONG.cutsceneType)
		{
			case 'senpai':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-pixel.png',
					'assets/images/weeb/pixelUI/dialogueBox-pixel.xml');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				like = "senpai";
			case 'angry-senpai':
				FlxG.sound.play('assets/sounds/ANGRY_TEXT_BOX' + TitleState.soundExt);

				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-senpaiMad.png',
					'assets/images/weeb/pixelUI/dialogueBox-senpaiMad.xml');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
				senpaiVisible = false;
				like = "angry-senpai";
			case 'spirit':
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-evil.png', 'assets/images/weeb/pixelUI/dialogueBox-evil.xml');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				textColor = FlxColor.WHITE;
				dropColor = FlxColor.BLACK;
				senpaiColor = FlxColor.BLACK;
				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic('assets/images/weeb/spiritFaceForward.png');
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
				like = "spirit";
			case 'none':
				// do nothing
			case 'monster':
				// do nothing
			default:
				if (FileSystem.exists('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/box.png')) {
					trace("here7");
					var rawPic = BitmapData.fromFile('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/box.png');
					trace("here8");
					var rawXml = File.getContent('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/box.xml');
					box.frames = FlxAtlasFrames.fromSparrow(rawPic,rawXml);
					trace("here9");
					var coolJsonFile:Dynamic = CoolUtil.parseJson(File.getContent('assets/images/custom_ui/dialog_boxes/dialog_boxes.json'));
					trace(PlayState.SONG.cutsceneType);
					trace(coolJsonFile);
					trace(Reflect.field(coolJsonFile,PlayState.SONG.cutsceneType));
					var coolAnimFile = CoolUtil.parseJson(File.getContent('assets/images/custom_ui/dialog_boxes/'+Reflect.field(coolJsonFile,PlayState.SONG.cutsceneType).like+'.json'));
					trace("here11");
					isPixel[2] = coolAnimFile.isPixel;
					senpaiVisible = coolAnimFile.senpaiVisible;
					sided = if (Reflect.hasField(coolAnimFile, 'sided')) coolAnimFile.sided else false;
					senpaiColor = FlxColor.fromString(coolAnimFile.senpaiColor);
					textColor = FlxColor.fromString(coolAnimFile.textColor);
					dropColor = FlxColor.fromString(coolAnimFile.dropColor);
					font = coolAnimFile.font;
					if (Reflect.hasField(coolAnimFile, "portraitOffset")) {
						portraitLeft.x += coolAnimFile.portraitOffset[0];
						portraitLeft.y += coolAnimFile.portraitOffset[1];
						portraitRight.x += coolAnimFile.portraitOffset[0];
						portraitRight.y += coolAnimFile.portraitOffset[1];
					}
					trace("here12");
					if (FileSystem.exists('assets/images/custom_ui/dialog_boxes/' + PlayState.SONG.cutsceneType + '/text.ogg'))
						clickSounds[2] = Sound.fromFile('assets/images/custom_ui/dialog_boxes/' + PlayState.SONG.cutsceneType + '/text.ogg');
					if (FileSystem.exists('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/accept.ogg'))
						acceptSound = Sound.fromFile('assets/images/custom_ui/dialog_boxes/' + PlayState.SONG.cutsceneType + '/accept.ogg');
					if (coolAnimFile.like == "senpai") {
						box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
						box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
						like = "senpai";
					} else if (coolAnimFile.like == "senpai-angry") {
						// should i keep this?
						if (FileSystem.exists('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/angry.ogg')) {
							var coolSound:Sound = Sound.fromFile('assets/images/custom_ui/dialog_boxes/' + PlayState.SONG.cutsceneType + '/angry.ogg');
							FlxG.sound.play(coolSound);
						} else {
							FlxG.sound.play('assets/sounds/ANGRY_TEXT_BOX' + TitleState.soundExt);
						}
						
						box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
						box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
						like = "angry-senpai";
					} else if (coolAnimFile.like == "spirit") {
						box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
						box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
						if (FileSystem.exists('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/face.png')) {
							var facePic = BitmapData.fromFile('assets/images/custom_ui/dialog_boxes/'+PlayState.SONG.cutsceneType+'/face.png');
							var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(facePic);
							if (isPixel[2]) {
								face.setGraphicSize(Std.int(face.width * 6));
							}

							add(face);
						}
						// NO ELSE TO SUPPORT CUSTOM PORTRAITS
						like = "spirit";
					}
				}
		}
		trace("here6");
		box.animation.play('normalOpen');
		if (dialogueList[0].startsWith(':dad:') && sided) {
			box.flipX = true;
		}
		if (isPixel[2]) {
			box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		} else {
			box.setGraphicSize(Std.int(box.width * 0.9));
		}
		if (clickSounds[0] == null)
			clickSounds[0] = clickSounds[2];
		if (clickSounds[1] == null)
			clickSounds[1] = clickSounds[2];
		box.updateHitbox();
		add(box);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic('assets/images/weeb/pixelUI/hand_textbox.png');
		add(handSelect);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);


		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.setFormat('assets/fonts/' + font, 32, dropColor);
		if (dropColor.alphaFloat != 1) 
			dropText.alpha = dropColor.alphaFloat;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.setFormat('assets/fonts/'+font, 32, textColor);
		if (textColor.alphaFloat != 1)
			swagDialogue.alpha = textColor.alphaFloat;
		swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);

		this.dialogueList = dialogueList;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// NOT HARD CODING CAUSE I BIG BBRAIN
		portraitLeft.color = senpaiColor;

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		// suss

		// when the music state is sus
		if (PlayerSettings.player1.controls.SECONDARY) 
		{
			// skip all this shit
			if (!isEnding)
			{
				isEnding = true;

				if (like == "senpai" || like == "spirit")
					FlxG.sound.music.fadeOut(2.2, 0);

				new FlxTimer().start(0.2, function(tmr:FlxTimer)
				{
					box.alpha -= 1 / 5;
					bgFade.alpha -= 1 / 5 * 0.7;
					portraitLeft.visible = false;
					portraitRight.visible = false;
					swagDialogue.alpha -= 1 / 5;
					dropText.alpha -= 1/5;
				}, 5);

				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
			}
		} else if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (like == "senpai" || like == "spirit")
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha -= 1 / 5;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// do it before the text starts
		if (portraitCustom != null) {
			remove(portraitCustom);
		}
		switch (curCharacter) {
			case 'dad':
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[1], 0.6)];
			case 'bf':
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[0], 0.6)];
			case 'char-bf':
				// we have to change the custom portrait
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/bfPortrait.png', 'assets/images/bfPortrait.xml');
				portraitCustom.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-dad':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/dadPortrait.png', 'assets/images/dadPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-gf':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/gfPortrait.png', 'assets/images/gfPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				flipX = true;
				portraitCustom.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			// TODO: Split into skid and pump
			case 'char-spooky':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/spookyPortrait.png', 'assets/images/spookyPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-pico':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/picoPortrait.png', 'assets/images/picoPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.flipX = true;
				portraitCustom.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-mom':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/momPortrait.png', 'assets/images/momPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			// TODO: Graphics
			case 'char-mom-xmas':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/momPortrait.png', 'assets/images/momPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			// TODO: Graphics
			case 'char-dad-xmas':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/dadPortrait.png', 'assets/images/dadPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-monster':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/monsterPortrait.png', 'assets/images/monsterPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-monster-xmas':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/monsterXmasPortrait.png', 'assets/images/christmas/monsterXmasPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-gf-xmas':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/gfPortraitXmas.png', 'assets/images/christmas/gfPortrait.xml');
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				flipX = true;
				portraitCustom.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-bf-xmas':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/bfPortraitXmas.png', 'assets/images/christmas/bfPortraitXmas.xml');
				portraitCustom.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			case 'char-bf-pixel':
				portraitCustom = new FlxSprite(0, 40);
				portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9 * PlayState.daPixelZoom));
				portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
				portraitCustom.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				swagDialogue.sounds = [FlxG.sound.load(clickSounds[2], 0.6)];
				portraitCustom.visible = false;
			default:
				var realChar = curCharacter.substr(5);
				portraitCustom = new FlxSprite(0, 40);
				var customPixel = false;
				if (FileSystem.exists('assets/images/custom_chars/'+realChar+'/portrait.png')) {
					var coolCustomJson = Character.getAnimJson(realChar);
					customPixel = if (Reflect.hasField(coolCustomJson, "isPixel"))
						coolCustomJson.isPixel
					else
						false;
					var rawPic = BitmapData.fromFile('assets/images/custom_chars/' + realChar + "/portrait.png");
					var rawXml = File.getContent('assets/images/custom_chars/' + realChar + "/portrait.xml");
					portraitCustom.frames = FlxAtlasFrames.fromSparrow(rawPic, rawXml);
				} else {
					portraitCustom.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
					customPixel = true;
				}
				var customFrameings:Array<FlxFrame> = [];
				for (frame in portraitCustom.frames.frames)
				{
					if (frame.name != null && StringTools.startsWith(frame.name, 'Boyfriend portrait enter'))
					{
						customFrameings.push(frame);
					}
				}
				if (FileSystem.exists('assets/images/custom_chars/' +realChar + '/text.ogg'))
				{
					swagDialogue.sounds = [FlxG.sound.load(Sound.fromFile('assets/images/custom_chars/' + realChar + '/text.ogg'))];
				} else {
					swagDialogue.sounds = [FlxG.sound.load(clickSounds[2])];
				}
				if (customFrameings.length > 0) {
					portraitCustom.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				} else {
					portraitCustom.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				}
				if (customPixel)
					portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9 * PlayState.daPixelZoom));
				else 
					portraitCustom.setGraphicSize(Std.int(portraitCustom.width * 0.9));
				portraitCustom.visible = false;
		}
		// swagDialogue.text = ;
		if (portraitCustom != null) {
			portraitCustom.updateHitbox();
			portraitCustom.scrollFactor.set();
			portraitCustom.x = portraitLeft.x;
			portraitCustom.y = portraitLeft.y;
			// note to self you must add it for it to work
			add(portraitCustom);
		}
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (portraitCustom != null) {
					portraitCustom.visible = false;
				}
				if (sided) {
					box.flipX = true;
				}
				if (!portraitLeft.visible && senpaiVisible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					trace(portraitLeft.animation.curAnim);
				}
			case 'bf':
				portraitLeft.visible = false;
				if (portraitCustom != null)
				{
					portraitCustom.visible = false;
				}
				// don't need to check for sided bc this changes nothing
				box.flipX = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			default:
				portraitLeft.visible = false;
				portraitRight.visible = false;
				

				if (!portraitCustom.visible) {
					portraitCustom.visible = true;
					trace(portraitCustom.animation);
					trace(portraitCustom);
					portraitCustom.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}