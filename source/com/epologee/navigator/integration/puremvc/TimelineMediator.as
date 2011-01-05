package com.epologee.navigator.integration.puremvc {
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TimelineMediator extends Mediator {
		public function TimelineMediator(inName : String, inTimeline : Sprite) {
			super(inName, inTimeline);
		}

		protected function get timeline() : Sprite {
			return viewComponent as Sprite;
		}

		protected function set timeline(inTimeline : Sprite) : void {
			viewComponent = inTimeline;
		}

		protected function addChild(inChild : DisplayObject) : DisplayObject {
			return timeline.addChild(inChild);
		}

		protected function addChildAt(inChild : DisplayObject, inIndex : int) : void {
			timeline.addChildAt(inChild, inIndex)
		}

		protected function removeChild(inChild : DisplayObject) : void {
			timeline.removeChild(inChild);
		}
	}
}