package com.epologee.ui.forms {
	import com.epologee.ui.forms.components.IFocusableElement;

	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class FormFocusEvent extends Event {
		public static const SUBMIT_KEY_PRESSED : String = "ENTER_KEY_PRESSED";
		//
		// public properties:
		public var focussedElement : IFocusableElement;

		public function FormFocusEvent(inType : String, inFocussed : IFocusableElement) {
			super(inType, false);
			focussedElement = inFocussed;
		}

		override public function clone() : Event {
			var c : FormFocusEvent = new FormFocusEvent(type, focussedElement);
			return c;
		}

		override public function toString() : String {
			// com.epologee.ui.forms.FormFocusEvent
			return getQualifiedClassName(this);
		}
	}
}
