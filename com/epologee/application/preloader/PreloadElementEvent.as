package com.epologee.application.preloader {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class PreloadElementEvent extends Event {
		public static const INITIALIZED:String = "initialized";
		public static const PROGRESS:String = "progress";
		//
		// public properties:
		
		public function PreloadElementEvent(inType:String) {
			super(inType, true);
		}
		
		override public function clone():Event {
			var c:PreloadElementEvent = new PreloadElementEvent(type);
			return c;
		}
		
		override public function toString():String {
			var s:String = "";
			// s = "[ " + name + " ]:";
			return s+getQualifiedClassName(this);
		}
	}
}
