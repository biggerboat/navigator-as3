package com.epologee.puremvc.navigation {
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigatorEvent extends Event {
		public static const TRANSITION_STATUS_UPDATED : String = "TRANSITION_STATUS_UPDATED";
		//
		// public properties:
		public var statusByResponder : Dictionary;

		public function NavigatorEvent(inType : String, inStatusByResponder:Dictionary) {
			super(inType, false);
			statusByResponder = inStatusByResponder;
		}

		override public function toString() : String {
			// com.epologee.puremvc.navigation.NavigatorEvent
			return getQualifiedClassName(this);
		}
	}
}
