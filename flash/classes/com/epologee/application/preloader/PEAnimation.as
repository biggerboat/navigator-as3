package com.epologee.application.preloader {
	import com.epologee.animation.timeline.FrameChecker;
	import com.epologee.animation.timeline.FrameEvent;
	import com.epologee.animation.timeline.FrameStatus;
	import com.epologee.time.TimeDelay;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class PEAnimation extends AbstractPreloadElement {
		private var _checker : FrameChecker;
		private var _isStarted : Boolean;
		private var _delay : int;
		private var _loop : Boolean;

		public function PEAnimation(inLoop : Boolean = true, inReadyDelay : int = 1000) {
			super(0);
			_loop = inLoop;
			_delay = inReadyDelay;
		}

		public function set timeline(inTimeline : MovieClip) : void {
			_checker = new FrameChecker(inTimeline);
			_checker.timeline.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			_checker.addEventListener(FrameEvent.STATUS_CHANGE, handleFrameStatusChanged);
			weight = _checker.totalFrames * 64000 / 31;
			
			if (_isStarted) {
				_checker.start();
			}
		}

		override public function start() : void {
			_isStarted = true;
			
			if (_checker) {
				_checker.start();
			}
		}

		private function handleEnterFrame(event : Event) : void {
			var updatedProgress : Number = _checker.currentFrame / _checker.totalFrames;
			if (updatedProgress == progress) return;
			
			progress = updatedProgress;
			dispatchProgress();
		}

		private function handleFrameStatusChanged(event : FrameEvent) : void {
			if (event.status & FrameStatus.LAST_FRAME) {
				_checker.timeline.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
				_checker.stop();
				if (!_loop) {
					_checker.timeline.stop();
				}
				
				new TimeDelay(dispatchReady, _delay);
			}
		}
	}
}
