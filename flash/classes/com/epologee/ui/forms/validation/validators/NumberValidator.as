package com.epologee.ui.forms.validation.validators {
	import com.epologee.ui.forms.validation.ICorrector;
	import com.epologee.ui.forms.validation.ValidationVO;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class NumberValidator implements ICorrector {
		public static const TYPE : String = "number";
		//
		public var errorMessage : String;
		public var errorID : String;

		public function NumberValidator(inErrorMessage : String, inErrorID : String = "") {
			errorMessage = inErrorMessage;
			errorID = inErrorID;
		}

		public function validate(inValidation : ValidationVO) : void {
			var reg : RegExp = /^\s*[0-9]+\s*$/i;
			inValidation.valid = reg.test(inValidation.element.value);
			
			if (inValidation.invalid) {
				inValidation.errorMessage = errorMessage;
				inValidation.errorID = errorID;
			}
		}

		public function correct(inValue : String) : String {
			var c : Number = parseInt(inValue);
			if (isNaN(c)) return "";
			return c.toString();
		}

		public function toString() : String {
			return "Validator: " + TYPE;
		}
	}
}