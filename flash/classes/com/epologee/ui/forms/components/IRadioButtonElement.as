package com.epologee.ui.forms.components {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IRadioButtonElement extends IFormElement {
		function get isOn() : Boolean;

		function turnOn() : void;

		function turnOff() : void;	
	}
}
