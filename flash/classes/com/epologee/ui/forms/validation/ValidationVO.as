package com.epologee.ui.forms.validation {
	import com.epologee.ui.forms.components.IValidatableElement;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class ValidationVO {
		public var valid : Boolean;
		public var errorMessage : String = "";
		public var errorID : String = "";
		//
		private var _element : IValidatableElement;

		public function ValidationVO(inElement:IValidatableElement) {
			_element = inElement;
		}

		public function get invalid():Boolean {
			return !valid;
		}
		
		public function get element() : IValidatableElement {
			return _element;
		}
		
		public function toString():String {
			return _element.dataName + "(" + _element.value + ") = " + valid;
		}
	}
}
