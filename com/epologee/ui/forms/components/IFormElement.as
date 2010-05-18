package com.epologee.ui.forms.components {
	import flash.events.IEventDispatcher;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IFormElement extends IEventDispatcher {
		/**
		 * The name to identify the elements value by.
		 */
		function get dataName() : String;

		/**
		 * Every form element has a string value. Even components that deal
		 * only with numeric in/output. This is because in the end, also every
		 * component value will be sent as a string to a backend.
		 */
		function get value() : String;

		function set value(inValue : String) : void;
		
		function get debugValue() : String;
		
		function get defaultValue() : String
		
		function get dispatchOnChange() : Boolean;

		function set dispatchOnChange(inFlag:Boolean):void;
		
		function disable() : void;

		function enable() : void; 
	}
}
