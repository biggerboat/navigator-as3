package com.epologee.ui.forms.validation.validators {
	import com.epologee.ui.forms.validation.ICorrector;
	import com.epologee.ui.forms.validation.ValidationVO;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class PhoneValidator implements ICorrector {
		public static const TYPE : String = "phone_NL";
		//
		public var errorMessage : String;
		public var errorID : String;

		public function PhoneValidator(inErrorMessage : String, inErrorID : String = "") {
			errorMessage = inErrorMessage;
			errorID = inErrorID;
		}

		public function validate(inValidation : ValidationVO) : void {
			var reg : RegExp = /^(((00|[+]){1}[1-9]{3})|0[1-9])[0-9]{8}$/;
			inValidation.valid = reg.test(inValidation.element.value);
			
			if (inValidation.invalid) {
				inValidation.errorMessage = errorMessage;
				inValidation.errorID = errorID;
			}
		}

		public function correct(inValue : String) : String {
			return inValue.replace(/\s*/gi, "");
		}

		public function toString() : String {
			return "Validator: " + TYPE;
		}
	}
}