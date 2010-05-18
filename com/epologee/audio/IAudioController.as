package com.epologee.audio {
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IAudioController {

		function get muted() : Boolean;

		function set muted(inMuted : Boolean) : void;

		function set masterVolume(inVolume : Number) : void;

		function get masterVolume() : Number;

		function getSoundNames() : Array;

		function getSounds() : Dictionary;

		function play(inName : String) : void;

		function stop(inName : String) : void;

		function setTrackBand(inName : String, inPosition : Number) : void ;

		function isPlaying(inName : String) : Boolean;
	}
}