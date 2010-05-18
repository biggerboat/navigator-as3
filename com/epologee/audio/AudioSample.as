package com.epologee.audio {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class AudioSample extends EventDispatcher implements IAudioSample {
		public var loops : Boolean = false;
		public var voiceCancelling : Boolean = false;
		//
		private var _name : String;	
		private var _sound : Sound;
		private var _channels : Array;
		private var _position : Number = 0;
		private var _masterVolume : Number;
		private var _currentVolume : Number;

		public function get name() : String {
			return _name;
		}

		public function get isPlaying() : Boolean {
			return _channels.length > 0;
		}

		public function get position() : Number {
			return _position;
		}
		
		public function get duration() : Number {
			return _sound.length;
		}

		public function AudioSample(inSound : Sound, inName : String) {
			_sound = inSound;
			_name = inName;
			_channels = [];
			
			setMasterVolume(1);
			setVolume(1);
		}

		public function setMasterVolume(inMasterVolume : Number) : void {
			_masterVolume = inMasterVolume;
			
			setVolume(_currentVolume);
		}

		public function setVolume(inVolume : Number) : void {
			_currentVolume = inVolume;
			var leni : int = _channels.length;
			for (var i : int = 0;i < leni; i++) {
				var channel : SoundChannel = SoundChannel(_channels[i]);
				var adjustedVolume : SoundTransform = channel.soundTransform;
				adjustedVolume.volume = _currentVolume * _masterVolume;
				channel.soundTransform = adjustedVolume;
			}
		}

		public function play() : void {
			startSound(0);
		}

		public function resume() : void {
			startSound(position);
		}

		public function stop() : void {
			var channel : SoundChannel;
			while (channel = _channels.shift() as SoundChannel) {
				channel.stop();
				removeChannel(channel);
			}
		}

		private function startSound(inPosition : Number) : void {
			if (voiceCancelling) stop();
			
			var channel : SoundChannel = _sound.play(inPosition, loops ? 0 : 1);
			_position = channel.position;
			channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);

			_channels.push(channel);
			
			setVolume(_currentVolume);
		}

		private function handleSoundComplete(event : Event) : void {
			var channel : SoundChannel = SoundChannel(event.target);
			_position = channel.position;
			removeChannel(channel);
			
			dispatchEvent(event);
		}

		private function removeChannel(inChannel : SoundChannel) : void {
			inChannel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);

			var leni : int = _channels.length;
			for (var i : int = 0;i < leni; i++) {
				if (_channels[i] == inChannel) {
					_channels.splice(i, 1);
					return;
				}
			}
		}

		override public function toString() : String {
			var s : String = "";
			s = "[ " + name + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}
