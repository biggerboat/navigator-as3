package com.epologee.animation.showhide {
	
	import com.epologee.time.TimeDelay;

	import flash.display.Stage;
	import flash.events.MouseEvent;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class AutoHideBehavior {
		private var _target : IShowHide;
		private var _timer : TimeDelay;
		private var _stage : Stage;
		private var _enabled : Boolean;
		private var _isOver : Boolean;

		public function get delay() : int {
			return _timer.delay;
		}

		public function set delay(inDelay : int) : void {
			_timer.delay = inDelay;
		}

		public function AutoHideBehavior(inTarget : IShowHide, inStage : Stage, inDelayMS : int = 500, inStartTimer:Boolean = false, inAutoEnable : Boolean = true) {
			_target = inTarget;
			_stage = inStage;
			
			_target.addEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			_target.addEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, handleStageMouseDown);

			if (inAutoEnable) {
				enable();
			}
			
			_timer = new TimeDelay(_target.hide, inDelayMS, null, false, false);
			
			if (inStartTimer) {
				_timer.resetAndStart();
			}
		}

		public function enable() : void {
			_enabled = true;
		}

		public function disable() : void {
			_enabled = false;
			_timer.reset();
		}

		public function clean() : void {
			_timer.die();
			_timer = null;
			
			_target.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
			_target.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleStageMouseDown);
		}

		private function hide() : void {
			if (!_enabled) return;
			if (!_target.isShowing()) return;
			
			_timer.reset();
			_target.hide();
		}

		private function handleRollOver(event : MouseEvent) : void {
			if (!_enabled) return;
			
			_isOver = true;
			_timer.reset();
		}

		private function handleRollOut(event : MouseEvent) : void {
			if (!_enabled) return;
			
			_isOver = false;
			_timer.resetAndStart();
		}

		/** 
		 * TODO: Improve
		 * It's not really elegant that the autohidebehavior handles
		 * stage clicks regardless of the target's visiblity status.
		 * Find a more elegant way to listen to the stage clicks only
		 * when target is visible.
		 * 
		 * Warning: the auto hide behavior should also work if the rollover
		 * event is not yet fired...
		 */
		private function handleStageMouseDown(event : MouseEvent) : void {
			if (!_isOver) {
				hide();
			}
		}
	}
}
