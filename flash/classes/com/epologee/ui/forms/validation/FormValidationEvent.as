package com.epologee.ui.forms.validation {
	import com.epologee.ui.forms.components.IValidatableElement;
	import com.epologee.ui.forms.components.IFormElement;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class FormValidationEvent extends Event {
		public static const ELEMENT_STATUS_CHANGE : String = "STATUS_CHANGE";
		public static const VALIDATION_SUCCESS : String = "VALID";
		public static const VALIDATION_FAILED : String = "INVALID";
		//
		// public properties:
		public var validation : ValidationVO;
		public var failedValidations : Array = [];

		public function FormValidationEvent(inType : String) {
			super(inType, false);
		}
		
		public function elementHasFailed(inElement:IValidatableElement) : Boolean {
			var leni : int = failedValidations.length;
			for (var i : int = 0; i < leni; i++) {
				var vvo : ValidationVO = ValidationVO(failedValidations[i]);
				if (vvo.element == inElement) {
					return vvo.invalid; 
				}
			}
			
			return false;
		}

		override public function clone() : Event {
			var c : FormValidationEvent = new FormValidationEvent(type);
			c.validation = validation;
			c.failedValidations = failedValidations;
			return c;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
