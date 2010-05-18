package com.epologee.ui.forms.submission {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class FormServiceEvent extends Event {
		public static const DONE_WITH_SUCCESS : String = "done with success";
		public static const DONE_WITH_ERRORS:String = "done with errors";
		public static const FAILED_CONNECTION:String = "failed connection";
		//
		// public properties:
		public var error:String;
		
		public function FormServiceEvent(inType : String, inError:String = null) {
			super(inType, true);
			error = inError;
		}

		override public function clone() : Event {
			var c : FormServiceEvent = new FormServiceEvent(type, error);
			return c;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}	
	}
}
