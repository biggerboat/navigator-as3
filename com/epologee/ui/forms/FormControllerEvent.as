package com.epologee.ui.forms {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class FormControllerEvent extends Event {
		public static const READY_FOR_SUBMISSION : String = "SUBMIT_FORM";

		public function FormControllerEvent(inType : String) {
			super(inType, true);
		}

		override public function clone() : Event {
			var c : FormControllerEvent = new FormControllerEvent(type);
			return c;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}	
	}
}
