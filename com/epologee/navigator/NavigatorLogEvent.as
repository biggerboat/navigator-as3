package com.epologee.navigator {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 *  Jankees van Woezik <jankees@base42.nl>
	 */
	public class NavigatorLogEvent extends Event {
		public static const MESSAGE : String = "NavigatorLogEvent.MESSAGE";
		//
		public static const TYPE_LOG : String = "NavigatorLogEvent.TYPE_LOG";
		public static const TYPE_ERROR : String = "NavigatorLogEvent.TYPE_ERROR";
		//
		//
		public var message : String;
		public var subtype : String;

		// 
		// public properties:
		public function NavigatorLogEvent(inSubtype : String, inMessage : String) {
			subtype = inSubtype;
			message = inMessage;
			super(MESSAGE, true);
		}

		override public function toString() : String {
			// com.epologee.navigator.NavigatorLogEvent
			return getQualifiedClassName(this);
		}
	}
}
