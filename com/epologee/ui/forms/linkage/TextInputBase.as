package com.epologee.ui.forms.linkage {
	import com.epologee.logging.Logee;
	import com.epologee.ui.forms.components.ITextInputElement;
	import com.epologee.ui.forms.components.ValidatableErrorElement;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class TextInputBase extends ValidatableErrorElement implements ITextInputElement {
		/**
		 * DATA NAME
		 */
		private var _textFields : Array = [];
		private var _inputField : TextField;
		private var _focalIndex : int;

		public function TextInputBase() {
			findInputField();
		}

		[Inspectable(name="Focal Index (tab)",defaultValue="-1")]

		public function set focalIndex(inIndex : int ) : void {
			_focalIndex = inIndex;
			assignTabIndex();
		}

		public function get focalIndex() : int {
			return _focalIndex;
		}

		public function get focusTarget() : InteractiveObject {
			return _inputField;
		}

		override public function set value(inValue : String) : void {
			super.value = inValue;

			var leni : int = _textFields.length;
			for (var i : int = 0;i < leni; i++) {
				var field : TextField = _textFields[i] as TextField;
				if (field) {
					field.text = value;
				}
			}			
		}

		override public function disable() : void {
			super.disable();
			var leni : int = _textFields.length;
			for (var i : int = 0;i < leni; i++) {
				var field : TextField = _textFields[i] as TextField;
				field.mouseEnabled = false;
				field.tabEnabled = false;
			}
		}

		override public function enable() : void {
			super.enable();
			
			var leni : int = _textFields.length;
			for (var i : int = 0;i < leni; i++) {
				var field : TextField = _textFields[i] as TextField;
				field.mouseEnabled = true;
				field.tabEnabled = true;
			}
		}

		private function findInputField() : void {
			_textFields = [];
			var leni : int = numChildren;
			for (var i : int = 0;i < leni; i++) {
				var textChild : TextField = getChildAt(i) as TextField;
				if (textChild) {
					textChild.addEventListener(Event.CHANGE, handleTextFieldChange);
					_textFields.push(textChild);
					
					if (!_inputField) {
						_inputField = textChild;
						assignTabIndex();
					}
				}
			}
			
			if (_inputField == null) {
				Logee.warn(this + " has no textfields!");
			}
		}
		
		private function assignTabIndex() : void {
			if (!isNaN(_focalIndex) && _inputField != null) {
				_inputField.tabIndex = _focalIndex;
			}
		}

		private function handleTextFieldChange(event : Event) : void {
			value = _inputField.text;
		}
	}
}