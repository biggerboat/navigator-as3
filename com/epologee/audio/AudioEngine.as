package com.epologee.audio {
	import com.epologee.development.logging.debug;
	import com.epologee.development.logging.warn;

	import flash.media.Sound;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class AudioEngine {

		private var _soundsByName : Dictionary;
		private var _masterVolume : Number;
		private var _muted : Boolean;

		public function AudioEngine() {
			_soundsByName = new Dictionary();
			_masterVolume = 1;
		}

		public function get muted() : Boolean {
			return _muted;
		}

		public function set muted(inMuted : Boolean) : void {
			_muted = inMuted;
			
			var modifiedVolume : Number = _muted ? 0 : _masterVolume;
			
			debug(inMuted + " --> " + modifiedVolume);
			for each (var s : IAudioSample in _soundsByName) {
				s.setMasterVolume(modifiedVolume);
			}
		}

		public function set masterVolume(inVolume : Number) : void {
			_masterVolume = inVolume;
			
			if (!_muted) {
				for each (var s : IAudioSample in _soundsByName) {
					s.setMasterVolume(inVolume);
				}
			}
		}

		public function get masterVolume() : Number {
			return _masterVolume;
		}

		public function addSound(inName : String, inSound : *, inLoop : Boolean = false) : IAudioSample {
			var s : IAudioSample;
			if (inSound is Sound) {
				s = addSample(inName, inSound, inLoop);
			} else if (inSound is Array) {
				s = addTrack(inName, inSound, inLoop);
			}
			
			_soundsByName[inName] = s;
			s.setMasterVolume(_masterVolume);
			
			return s;
		}

		public function play(inName : String) : void {
			var ms : IAudioSample = _soundsByName[inName] as IAudioSample;
			if (!ms) {
				warn(inName + " not found");
				return;
			}
			
			ms.play();
		}

		public function isPlaying(inName : String) : Boolean {
			var ms : IAudioSample = _soundsByName[inName] as IAudioSample;
			if (!ms) {
				warn(inName + " not found");
				return false;
			}
			
			return ms.isPlaying;
		}

		public function stop(inName : String) : void {
			var ms : IAudioSample = _soundsByName[inName] as IAudioSample;
			if (!ms) {
				warn(inName + " not found");
				return;
			}
			
			ms.stop();
		}

		public function setTrackBand(inName : String, inPosition : Number) : void {
			var t : IAudioTrack = _soundsByName[inName] as IAudioTrack;
			if (!t) {
				warn(inName + " is not an AudioTrack");
				return;
			}
			
			t.setBand(inPosition);
		}

		public function getSoundByName(inName : String) : IAudioSample {
			var ms : IAudioSample = _soundsByName[inName] as IAudioSample;

			if (!ms) {
				warn(inName + " not found");
			}
			
			return ms;
		}

		public function getSounds() : Dictionary {
			return _soundsByName;
		}

		public function getSoundNames() : Array {
			var names : Array = [];
			for (var n : String in _soundsByName) {
				names.push(n);
			}
			return names;
		}

		private function addTrack(inName : String, inSoundInstances : Array, inLoops : Boolean, inMode : String = null) : IAudioTrack {
			var t : AudioTrack = new AudioTrack(inName, inSoundInstances, inLoops, inMode ? inMode : AudioTrack.SEAMLESS_MODE);
			
			return t;
		}

		private function addSample(inName : String, inSound : Sound, inLoop : Boolean) : IAudioSample {
			var s : AudioSample = new AudioSample(inSound, inName);
			s.loops = inLoop;
			
			return s;
		}

		public function toString() : String {
			var s : String = "";
			// s = "[ " + name + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}

