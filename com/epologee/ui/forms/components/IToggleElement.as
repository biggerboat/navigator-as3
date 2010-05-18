package com.epologee.ui.forms.components {

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IToggleElement extends IFormElement {
		function get isOn() : Boolean;
		
		function get valueOn() : String; 

		function get valueOff() : String ;

		function toggle() : void;

		function turnOn() : void;

		function turnOff() : void;
	}
}
