package com.epologee.ui.forms.components {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IErrorDisplay {
		/**
		 * @param inErrors a list of string values
		 */
		function display(inErrors : Array) : void;

		function clear() : void;
	}
}
