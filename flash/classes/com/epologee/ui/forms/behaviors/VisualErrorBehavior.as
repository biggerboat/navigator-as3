package com.epologee.ui.forms.behaviors {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class VisualErrorBehavior {
		private var _errorVisual : Sprite;
		private var _messageField : TextField;

		public function VisualErrorBehavior(inTarget : MovieClip) {
			if (inTarget.tError) {
				_errorVisual = inTarget.tError as Sprite;
				hideError();
			}
			
			if (inTarget.tMessage) {
				_messageField = inTarget.tMessage as TextField;
				_messageField.text = "";
			}
		}

		public function showError(inOptionalMessage : String = "") : void {
			if (!_errorVisual && !_messageField) return;
			
			if (_errorVisual) {
				_errorVisual.visible = true;
			}
			if (_messageField) {
				_messageField.text = inOptionalMessage;
			}
		}

		public function hideError() : void {
			if (_errorVisual) {
				_errorVisual.visible = false;
			}
			
			if (_messageField) {
				_messageField.text = "";
			}
		}
	}
}
