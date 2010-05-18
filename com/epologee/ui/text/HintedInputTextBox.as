package com.epologee.ui.text {
	import com.epologee.logging.Logee;

	import flash.events.FocusEvent;
	import flash.text.TextFieldType;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class HintedInputTextBox extends FormattedTextBox {
		private var _hint : String = "";
		private var _hasFocus : Boolean;
		private var _hintColor : uint;
		private var _inputColor : uint;

		public function HintedInputTextBox(inFont : String, inFontSize : Number = 12, inInputColor : uint = 0x000000, inHintColor : uint = 0xCCCCCC, inBold : Boolean = false, inItalic : Object = false) {
			super(inFont, inFontSize, inInputColor, inBold, inItalic);
			
			_inputColor = inInputColor;
			_hintColor = inHintColor;
			
			type = TextFieldType.INPUT;
			selectable = true;

			addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
		}

		public function get input() : String {
			if (text.replace(/\s+/gi, " ") == _hint.replace(/\s+/gi, " ")) {
				return "";
			}
			
			if (text.replace(/\s+/gi, "").length == 0) {
				return "";
			}
			
			return text;
		}

		public function get hint() : String {
			return _hint;
		}

		public function set hint(inHint : String) : void {
			var forceHint : Boolean = false;
			if (input == "") {
				forceHint = true;
			}
			_hint = inHint;

			showHint(true);
		}

		public function set hintColor(hintColor : uint) : void {
			_hintColor = hintColor;

			showHint();
		}

		private function handleFocusIn(event : FocusEvent) : void {
			_hasFocus = true;
			
			hideHint();
		}

		
		private function handleFocusOut(event : FocusEvent = null) : void {
			_hasFocus = false;
			
			showHint();
		}

		private function hideHint() : void {
			if (input == "") {
				textColor = _inputColor;
				replaceText(0, text.length, "");
			}
		}

		private function showHint(inForceHint:Boolean = false) : void {
			if (input == "" || inForceHint) {
				textColor = _hintColor;
				replaceText(0, text.length, _hint);
			}
		}
	}
}
