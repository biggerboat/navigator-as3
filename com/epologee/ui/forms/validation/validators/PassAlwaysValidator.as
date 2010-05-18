package com.epologee.ui.forms.validation.validators {
	import com.epologee.ui.forms.validation.IValidator;
	import com.epologee.ui.forms.validation.ValidationVO;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class PassAlwaysValidator implements IValidator {
		public static const TYPE : String = "none";

		public function validate(inValidation : ValidationVO) : void {
			inValidation.valid = true;
		}		
		
		public function toString() : String {
			return "Validator: " + TYPE;
		}
	}
}