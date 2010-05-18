package com.epologee.ui.forms.components {

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IValidatableElement extends IFormElement {
		function get validationType():String;
		function get autoCorrect():Boolean;
	}
}
