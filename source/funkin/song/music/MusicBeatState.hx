package funkin.song.music;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.util.FlxTimer;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var totalBeats:Int = 0;
	private var totalSteps:Int = 0;

	private var curSection:Int = 0;
	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		#if (!web)
		// TitleState.soundExt = '.ogg';
		#end

		super.create();

		// prettyPrint('Controls: ${controls}');
	}

	override function update(elapsed:Float)
	{
		everyStep();

		updateCurStep();
		// Needs to be ROUNED, rather than ceil or floor
		updateBeat();

		super.update(elapsed);
	}

	override function openSubState(substate:FlxSubState)
	{
		os(substate);
		super.openSubState(substate);
	}

	public function os(substate:FlxSubState) {}

	private function updateBeat():Void
	{
		curBeat = Math.round(curStep / 4);
	}

	/**
	 * CHECKS EVERY FRAME
	 */
	private function everyStep():Void
	{
		if (Conductor.songPosition > lastStep + Conductor.stepCrochet - Conductor.safeZoneOffset
			|| Conductor.songPosition < lastStep + Conductor.safeZoneOffset)
		{
			if (Conductor.songPosition > lastStep + Conductor.stepCrochet)
			{
				stepHit();
			}
		}
	}

	private function updateCurStep():Void
	{
		curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		totalSteps += 1;
		lastStep += Conductor.stepCrochet;

		// If the song is at least 3 steps behind
		if (Conductor.songPosition > lastStep + (Conductor.stepCrochet * 3))
		{
			lastStep = Conductor.songPosition;
			totalSteps = Math.ceil(lastStep / Conductor.stepCrochet);
		}

		if (totalSteps % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		lastBeat += Conductor.crochet;
		totalBeats += 1;

		if (totalBeats % 4 == 0)
			sectionHit();

		#if sys
		//	trace(223);
		System.gc();
		#end
	}

	public function sectionHit():Void
	{
		curSection += 1;
	}

	public static function prettyPrint(text:String):Void
	{
		#if sys
		var header = "______";
		for (i in 0...text.length)
			header += "_";
		Sys.println("");
		Sys.println('$header');
		Sys.println('|   $text   |');
		Sys.println('|$header|');
		#end
	}
}
