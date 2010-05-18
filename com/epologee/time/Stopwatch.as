package com.epologee.time {
	import com.epologee.development.logging.debug;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;

	/**
	 * @author Eric-Paul Lecluse
	 */
	public class Stopwatch {
		public static const SPEED_FACTOR : uint = 1;
		//
		private var _isRunning : Boolean;
		private var _startTime : int;
		private var _stopTime : int;
		private var _logTimer : Timer;

		public function Stopwatch() {
			reset();
		}

		/**
		 * @return -1 when reset or not yet started. If already running or paused, 
		 * will return the amount of milliseconds watched.
		 */
		public function get time() : int {
			if (_isRunning) {
				return SPEED_FACTOR * (getTimer() - _startTime);
			}
			if (_stopTime > _startTime) {
				return SPEED_FACTOR * (_stopTime - _startTime);
			}
			return -1;
		}

		public function reset() : void {
			_startTime = 0;
			_stopTime = 0;
			_isRunning = false;
		}

		public function start() : void {
			if (_isRunning) return;
			
			_isRunning = true;
			if (_stopTime) {
				_startTime += getTimer() - _stopTime;
			} else {
				_startTime = getTimer();
			}
		}

		public function jumpStart(inToTimeMS : int) : void {
			_isRunning = true;
			
			_stopTime = _startTime = getTimer() - inToTimeMS;
		}

		public function stop() : void {
			if (!_isRunning) return;
			
			_isRunning = false;
			_stopTime = getTimer();
		}

		public function log(inTraceLog : Boolean = true) : void {
			if (inTraceLog) {
				_logTimer = new Timer(1000, 0);
				_logTimer.addEventListener(TimerEvent.TIMER, handleLogTick);
				_logTimer.start();
			} else {
				_logTimer.removeEventListener(TimerEvent.TIMER, handleLogTick);
				_logTimer.stop();
			}
		}

		private function handleLogTick(e : Event) : void {
			if (!_isRunning) return;
			debug(".... " + time);
		}
		
		public function isRunning() : Boolean {
			return _isRunning;
		}
	}
}
