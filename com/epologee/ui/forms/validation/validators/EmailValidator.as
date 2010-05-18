package com.epologee.ui.forms.validation.validators {
	import com.epologee.ui.forms.validation.IValidator;
	import com.epologee.ui.forms.validation.ValidationVO;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class EmailValidator implements IValidator {
		public static const TYPE:String = "e-mail";
		//
		public var errorMessage : String;
		public var errorID : String;

		public function EmailValidator(inErrorMessage:String, inErrorID:String = "") {
			errorMessage = inErrorMessage;
			errorID = inErrorID;
		}

		public function validate(inValidation : ValidationVO) : void {
			var reg : RegExp = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i;
			inValidation.valid = reg.test(inValidation.element.value);
			
			if (inValidation.invalid) {
				inValidation.errorMessage = errorMessage;
				inValidation.errorID = errorID;
			}
		}
		
		public function toString():String {
			return "Validator: "+TYPE;
		}
	}
}