package com.epologee.audio {
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class BaseAudioController extends Sprite implements IAudioController {

		private var _engine : AudioEngine;
		private var _debug : Boolean;

		public function BaseAudioController() {
			_debug = (stage != null);
			
			_engine = new AudioEngine();
			
			initializeSounds();
			
			if (_debug) {
				var names : Array = _engine.getSoundNames();
				if (names.length) {
					_engine.play(names[0]);
				}
			}
		}

		public function get engine() : AudioEngine {
			return _engine;
		}

		public function getSoundNames() : Array {
			return _engine.getSoundNames();
		}

		public function getSounds() : Dictionary {
			return _engine.getSounds();
		}

		public function play(inName : String) : void {
			_engine.play(inName);
		}

		public function stop(inName : String) : void {
			_engine.stop(inName);
		}

		public function setTrackBand(inName : String, inBandPosition : Number) : void {
			_engine.setTrackBand(inName, inBandPosition);
		}

		public function set masterVolume(inVolume : Number) : void {
			_engine.masterVolume = inVolume;
		}

		public function get masterVolume() : Number {
			return _engine.masterVolume;
		}

		public function set muted(inMuted : Boolean) : void {
			_engine.muted = inMuted;
		}

		public function get muted() : Boolean {
			return _engine.muted;
		}

		public function isPlaying(inName : String) : Boolean {
			return _engine.isPlaying(inName);
		}

		protected function initializeSounds() : void {
			throw new Error("override this method, call _engine.addSample / _engine.addTrack here");
		}
	}
}
