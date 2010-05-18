package com.epologee.ui.forms.validation.validators {
	import com.epologee.ui.forms.validation.IValidator;
	import com.epologee.ui.forms.validation.ValidationVO;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class YesValidator implements IValidator {
		public static const TYPE : String = "must be yes";
		public var errorMessage : String;
		public var errorID : String;

		public function YesValidator(inErrorMessage : String, inErrorID : String = "") {
			errorMessage = inErrorMessage;
			errorID = inErrorID;
		}

		public function validate(inValidation : ValidationVO) : void {
			inValidation.valid = (inValidation.element.value == "yes");

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
