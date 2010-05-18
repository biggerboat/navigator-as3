package com.epologee.util.drawing {
	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DrawBehavior {
		private static var _target : IDrawable;
		private var _scheduled : Boolean;

		public function DrawBehavior(inTarget : IDrawable) {
			_target = inTarget;
		}

		public function draw() : void {
			_scheduled = true;
			
			if (_target.parent) {
				_target.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
				return;
			}
			
			_target.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);			
		}

		private function handleEnterFrame(event : Event) : void {
			_target.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			execute();
		}

		private function handleAddedToStage(event : Event) : void {
			_target.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			execute();
		}

		private function execute() : void {
			if (!_scheduled) return;
			
			_scheduled = false;
			_target.draw();
		}
	}
}
