package com.epologee.ui.forms.validation {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface ICorrector extends IValidator {
		function correct(inValue:String):String;
	}
}
