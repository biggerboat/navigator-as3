package com.epologee.ui.scrolling {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ScrollBehaviorEvent extends Event {
		public static const SCROLL:String = "SCROLL";
		
		public function ScrollBehaviorEvent(inType:String) {
			super(inType, true);
		}
		
		override public function clone():Event {
			var c:ScrollBehaviorEvent = new ScrollBehaviorEvent(type);
			return c;
		}
		
		override public function toString():String {
			return getQualifiedClassName(this);
		}
	}
}
