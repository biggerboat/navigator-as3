package com.epologee.time {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;		

	public class TimeDelay {
		private var _callback : Function;
		private var _parameters : Array;
		private var _timer : Timer;
		private var _cleanup : Boolean;

		public function get delay() : int {
			return _timer.delay;
		}

		public function set delay(inDelay : int) : void {
			_timer.delay = inDelay;
		}

		/**
		 * Creates a new TimeDelay. Starts the delay immediately.
		 * @param inCallback: the callback function to be called when done waiting
		 * @param inTime: the number of frames to wait; when left out, or set to 1 or 0, one frame is waited
		 * @param inParams: list of parameters to pass to the callback function
		 * @param inStartInstantly: if set to false, you have to call resetAndStart() manually.
		 */
		public function TimeDelay(inCallback : Function, inTime : int = 1000, inParams : Array = null, inStartInstantly : Boolean = true, inCleanupAfterDelay : Boolean = true) {
			_callback = inCallback;
			_parameters = inParams;
			
			_timer = new Timer(inTime, 1);
			_timer.addEventListener(TimerEvent.TIMER, handleEnterTime);
			
			_cleanup = inCleanupAfterDelay;
			
			if (inStartInstantly) {
				resetAndStart();
			}
		}

		/**
		 * If you want to stop and reset the timer after it started running, use this method.
		 * There's also the resetAndStart() method
		 */
		public function reset() : void {
			_timer.stop();
		}

		/**
		 * This method may be called to start the timer in case the instant parameter was set to false,
		 * but you can also use it after a method is already running to "bump up" the delay to it's original
		 * value. Great for postponing the delay while the user is still clicking a mouse, for example.
		 */
		public function resetAndStart() : void {
			_timer.reset();
			_timer.start();
		}

		/**
		Release reference to creating object.
		Use this to remove a TimeDelay object that is still running when the creating object will be removed.
		 */
		public function die() : void {
			if (_timer) {
				_timer.removeEventListener(TimerEvent.TIMER, handleEnterTime);
				_timer.stop();
			}
			_timer = null;
			_callback = null;
			_parameters = null;
		}

		/**
		 * Handle the onEnterTime event.
		 * Checks if still waiting - when true: calls callback function.
		 * @param e: not used
		 */
		private function handleEnterTime(e : Event) : void {
			if (_parameters == null) {
				_callback();
			} else {
				_callback.apply(null, _parameters);
			}

			if (_cleanup) {
				die();
			}
		}
	}
}