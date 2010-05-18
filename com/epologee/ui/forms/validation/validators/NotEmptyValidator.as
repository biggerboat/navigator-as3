package com.epologee.ui.forms.validation.validators {
	import com.epologee.ui.forms.validation.IValidator;
	import com.epologee.ui.forms.validation.ValidationVO;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class NotEmptyValidator implements IValidator {
		public static const TYPE : String = "not empty";
		//
		public var errorMessage : String;
		public var errorID : String;

		public function NotEmptyValidator(inErrorMessage : String, inErrorID : String = "") {
			errorMessage = inErrorMessage;
			errorID = inErrorID;
		}

		public function validate(inValidation : ValidationVO) : void {
			var reg : RegExp = /\S+/g;
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