package com.epologee.ui.forms {
	import com.epologee.logging.Logee;
	import com.epologee.ui.forms.components.IFocusableElement;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	internal class FormFocus extends EventDispatcher {
		private var _index : int;
		private var _elements : Array;
		private var _container : Sprite;
		private var _isDirty : Boolean;
		private var _focussed : IFocusableElement;

		public function FormFocus() {
			_elements = [];
			_index = 0;
		}

		public function setStageContainer(inStageContainer : Sprite) : void {
			_container = inStageContainer;
		}

		public function removeElement(inElement : IFocusableElement) : void {
			var leni : int = _elements.length;
			for (var i : int = 0;i < leni;i++) {
				if (_elements[i] == inElement) {
					_elements.splice(i, 1);
					return;
				}
			}
		}

		public function addElement(inElement : IFocusableElement) : void {
			_isDirty = true;
			removeElement(inElement);
			_elements.push(inElement);
			inElement.focusTarget.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, handleKeyFocusChange);
			inElement.focusTarget.addEventListener(FocusEvent.FOCUS_IN, handleKeyFocusChange);
			inElement.focusTarget.addEventListener(FocusEvent.FOCUS_OUT, handleKeyFocusChange);
			inElement.focusTarget.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, handleKeyFocusChange);
			inElement.focusTarget.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyParticular);
		}

		private function handleKeyParticular(event : KeyboardEvent) : void {
			switch (event.keyCode) {
				case Keyboard.ENTER:
					if (_focussed) {
						dispatchEvent(new FormFocusEvent(FormFocusEvent.SUBMIT_KEY_PRESSED, _focussed));
					}
					break;
			}
		}

		private function handleKeyFocusChange(event : FocusEvent) : void {
//			Logee.debug("handleKeyFocusChange: " + event.type + " --> " + event.keyCode + " mouse down = " + _mouseDown);
			switch (event.type) {
				case FocusEvent.FOCUS_IN:
					_focussed = findElement(event.target as InteractiveObject);
					break;
				case FocusEvent.FOCUS_OUT:
					_focussed = null;
					break;
			}
		}

		private function findElement(focus : InteractiveObject) : IFocusableElement {
			if (focus && focus.parent && focus.parent is IFocusableElement) {
				return IFocusableElement(focus.parent);
			} else if (focus && focus.parent) {
				return findElement(focus.parent);
			} else {
				return null;
			}
		}

		private function compareIndex(a : IFocusableElement, b : IFocusableElement) : Number {
			return a.focalIndex > b.focalIndex ? 1 : -1;
		}

		override public function toString() : String {
			var s : String = "";
			// s = "[ " + name + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}
