package com.epologee.ui.forms.components {
	import com.epologee.ui.forms.behaviors.VisualErrorBehavior;
	import com.epologee.ui.forms.validation.validators.PassAlwaysValidator;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class ValidatableErrorElement extends FormElement implements IValidatableElement, IErrorElement {
		private var _visualErrorBehavior : VisualErrorBehavior;
		private var _errorShowing : Boolean;
		private var _autoCorrect : Boolean = false;
		private var _validationType : String = PassAlwaysValidator.TYPE;
		private var _customValidationType : String;

		[Inspectable(name="Validation",enumeration="none,e-mail,postcode_NL,must be yes,not empty",defaultValue="none")]

		public function set validationType(inType : String) : void {
			_validationType = inType;
		}

		public function get validationType() : String {
			return (_customValidationType ? _customValidationType : _validationType);
		}

		[Inspectable(name="Validation (custom)",defaultValue="")]

		public function set customValidationType(inType : String) : void {
			_customValidationType = inType;
		}

		[Inspectable(name="Validator Auto Correct",defaultValue=false)]

		public function set autoCorrect(inValue : Boolean) : void {
			_autoCorrect = inValue;
		}

		public function get autoCorrect() : Boolean {
			return _autoCorrect;
		}

		public function ValidatableErrorElement() {
			super();
			
			_visualErrorBehavior = new VisualErrorBehavior(this);
		}

		public function showError(inOptionalMessage : String = "") : void {
			_errorShowing = true;
			_visualErrorBehavior.showError(inOptionalMessage);	
		}

		public function hideError() : void {
			_errorShowing = false;
			_visualErrorBehavior.hideError();	
		}

		override public function enable() : void {
			super.enable();
			if (_errorShowing) {
				showError();
			}
		}

		override public function disable() : void {
			super.disable();
			_visualErrorBehavior.hideError();
		}
	}
}