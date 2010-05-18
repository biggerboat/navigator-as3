package com.epologee.audio {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class AudioLoader extends EventDispatcher {
		private var _loader : Loader;
		private var _audioController : IAudioController;
		private var _isLoading : Boolean;

		public function get audioController() : IAudioController {
			return _audioController;
		}

		public function get isLoading() : Boolean {
			return _isLoading;
		}

		public function AudioLoader() {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
		}

		public function load(inURL : String) : void {
			if (_isLoading) return;
			
			_isLoading = true;
			var context : LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			_loader.load(new URLRequest(inURL), context);
		}

		private function handleLoadProgress(event : ProgressEvent) : void {
			dispatchEvent(event);
		}

		private function handleLoadComplete(event : Event) : void {
			_audioController = _loader.content as IAudioController;
			_isLoading = true;
			dispatchEvent(event);
		}
	}
}
