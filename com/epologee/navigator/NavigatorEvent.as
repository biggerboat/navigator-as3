package com.epologee.navigator {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	


	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigatorEvent extends Event {
		public static const TRANSITION_STATUS_UPDATED : String = "TRANSITION_STATUS_UPDATED";
		public static const STATE_CHANGED : String = "STATE_CHANGED";
		//
		// public properties:
		public var statusByResponder : Dictionary;
		public var state : NavigationState;

		public function NavigatorEvent(inType : String, inStatusByResponder:Dictionary = null) {
			super(inType, false);
			statusByResponder = inStatusByResponder;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
