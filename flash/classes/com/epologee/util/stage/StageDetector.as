package com.epologee.util.stage {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class StageDetector {
		private static var _target : IInitializable;

		public static function initializeOnce(inTarget:IInitializable, inOptionalDisplayObject:DisplayObject = null) : void {
			_target = inTarget;
			
			if (inOptionalDisplayObject) {
				inOptionalDisplayObject.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
				return;
			}
			
			if (inTarget is EventDispatcher) {
				EventDispatcher(inTarget).addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			}
		}
		
		private static function handleAddedToStage(event : Event) : void {
			EventDispatcher(event.target).removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			_target.initialize();
			_target = null;
		}
	}
}
