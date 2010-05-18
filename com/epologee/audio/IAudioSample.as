package com.epologee.audio {
	import flash.events.IEventDispatcher;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IAudioSample extends IEventDispatcher {
		function play() : void;

		function stop() : void;

		function setMasterVolume(inMasterVolume : Number) : void;

		function setVolume(inVolume : Number) : void;

		function get name() : String;

		function get isPlaying() : Boolean;

		function get duration() : Number;
	}
}
