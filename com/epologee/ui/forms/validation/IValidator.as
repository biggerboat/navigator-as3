package com.epologee.ui.forms.validation {

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IValidator {
		function validate(inValidation : ValidationVO) : void;
		function toString():String;
	}
}
