package com.epologee.navigator.integration.puremvc {
	import com.epologee.navigator.NavigationState;

	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Use this class to trigger navigation requests from within a component.
	 */
	public class NavigationEvent extends Event {
		public static const REQUEST_STATE:String = "REQUEST_STATE";
		//
		// public properties:
		public var state:NavigationState;
		
		public function NavigationEvent(inType:String, inPath:String = "") {
			super(inType, true);
			state = new NavigationState(inPath);
		}

		override public function clone():Event {
			var c:NavigationEvent = new NavigationEvent(type);
			return c;
		}
		
		override public function toString():String {
			// com.epologee.puremvc.navigation.NavigationEvent
			return getQualifiedClassName(this);
		}
	}
}
