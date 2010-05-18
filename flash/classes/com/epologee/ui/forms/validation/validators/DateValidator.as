package com.epologee.ui.forms.validation.validators {
	import com.epologee.ui.forms.validation.ICorrector;
	import com.epologee.ui.forms.validation.ValidationVO;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DateValidator implements ICorrector {
		public static const TYPE : String = "date_NL";
		//
		public var errorID : String;
		public var errorMessage : String;

		public function DateValidator(inErrorMessage : String, inErrorID : String = "") {
			errorMessage = inErrorMessage;
			errorID = inErrorID;
		}

		public function correct(inValue : String) : String {
			var value : String = inValue;
			value = value.replace(/\s*/g, "");
			value = value.replace(/[\-.\\\/]/g, "/");
			return value;
		}

		public function validate(inValidation : ValidationVO) : void {
			var reg : RegExp = /^([0-9]{1,2}[\-.\\\/]{1}){2}[0-9]{4}$/i;
			inValidation.valid = reg.test(inValidation.element.value);
			
			if (inValidation.invalid) {
				inValidation.errorMessage = errorMessage;
				inValidation.errorID = errorID;
			}
		}

		public function toString() : String {
			return "Validator: " + TYPE;
		}
	}
}
