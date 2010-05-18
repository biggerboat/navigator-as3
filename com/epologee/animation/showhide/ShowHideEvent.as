package com.epologee.animation.showhide {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ShowHideEvent extends Event {
		public static const HIDE:String = "HIDE";
		public static const SHOW:String = "SHOW";
		//
		// public properties:
		
		public function ShowHideEvent(inType:String) {
			super(inType, false);
		}
		
		override public function clone():Event {
			var c:ShowHideEvent = new ShowHideEvent(type);
			return c;
		}
		
		override public function toString():String {
			return getQualifiedClassName(this);
		}
	}
}
