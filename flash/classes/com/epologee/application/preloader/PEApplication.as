package com.epologee.application.preloader {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class PEApplication extends AbstractPreloadElement {
		private var _timeline : DisplayObjectContainer;

		public function PEApplication(inTimeline : DisplayObjectContainer) {
			_timeline = inTimeline;
		}

		override public function start() : void {
			_timeline.addEventListener(Event.ENTER_FRAME, handleApplicationFrame);
		}

		private function handleApplicationFrame(event : Event) : void {
			weight = _timeline.loaderInfo.bytesTotal;

			var progressUpdated : Number = _timeline.loaderInfo.bytesLoaded /  _timeline.loaderInfo.bytesTotal;
			if (progressUpdated == progress) return;
			
			progress = progressUpdated;
			
			dispatchProgress();
				
			if (progress == 1) {
				_timeline.removeEventListener(Event.ENTER_FRAME, handleApplicationFrame);
				removeEventListener(Event.ENTER_FRAME, handleApplicationFrame);
				dispatchReady();	
			}
		}
	}
}
