package com.epologee.ui.forms.components {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class FormElementEvent extends Event {
		public static const VALUE_CHANGED : String = "value changed";
		public static const ELEMENT_SELECTED : String = "element selected";
		//
		// public properties:
		private var _element : IFormElement;

		public function get element() : IFormElement {
			return _element;
		}

		public function FormElementEvent(inType : String, inElement : IFormElement) {
			super(inType, false);
			_element = inElement;
		}

		override public function clone() : Event {
			var c : FormElementEvent = new FormElementEvent(type, _element);
			return c;
		}

		override public function toString() : String {
			return getQualifiedClassName(this);
		}
	}
}
