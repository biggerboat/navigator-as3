package com.epologee.application.preloader {
	import com.epologee.time.Stopwatch;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class PETimer extends AbstractPreloadElement {
		private var _sw : Stopwatch;
		private var _time : int;
		private var _timer : Timer;

		public function PETimer(inTime : int = 2500, inUpdateIntervalMS : int = 100) {
			super(inTime * 64);
			
			_sw = new Stopwatch();
			_time = inTime;

			_timer = new Timer(inUpdateIntervalMS);
			_timer.addEventListener(TimerEvent.TIMER, handleTimerEvent);
		}

		override public function start() : void {
			_sw.start();
			_timer.start();	
		}

		private function handleTimerEvent(event : TimerEvent) : void {
			if (_sw.time >= _time) {
				progress = 1;
				_timer.stop();
				_sw.stop();
				dispatchProgress();
				dispatchReady();
				return;
			}
			
			progress = _sw.time / _time;
			dispatchProgress();
		}
	}
}
