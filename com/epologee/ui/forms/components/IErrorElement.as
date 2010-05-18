package com.epologee.ui.forms.components {

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IErrorElement extends IFormElement {
		function showError(inOptionalMessage:String = "") : void;
		function hideError() : void;
	}
}
