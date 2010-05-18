package com.epologee.ui.forms.validation {
	import com.epologee.logging.Logee;
	import com.epologee.ui.forms.components.IValidatableElement;
	import com.epologee.ui.forms.validation.validators.PassAlwaysValidator;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class FormValidation extends EventDispatcher {
		public static const VALID : String = "VALID";
		public static const INVALID : String = "INVALID";
		public static const UNKNOWN : String = "UNKNOWN";
		//
		private var _elements : Array;
		private var _validators : Dictionary;
		private var _validationResults : Array;
		private var _validationByElement : Dictionary;
		private var _status : String = UNKNOWN;

		public function FormValidation() {
			_validators = new Dictionary();
			_validationByElement = new Dictionary();
			_elements = [];

			registerValidator(new PassAlwaysValidator(), PassAlwaysValidator.TYPE);
		}

		public function registerValidator(inValidator : IValidator, inType : String) : void {
			_validators[inType] = inValidator;
		}

		public function addElement(inElement : IValidatableElement) : void {
			var leni : int = _elements.length;
			for (var i : int = 0;i < leni;i++) {
				if (_elements[i] == inElement) {
					return;
				}
			}

			_elements.push(inElement);
		}

		public function removeElement(inElement : IValidatableElement) : void {
			var leni : int = _elements.length;
			for (var i : int = 0;i < leni;i++) {
				if (_elements[i] == inElement) {
					_elements.splice(i, 1);
					return;
				}
			}
		}

		public function get messages() : Array {
			var messages : Array = [];
			
			var leni : int = _validationResults.length;
			for (var i : int = 0;i < leni ;i++) {
				var vvo : ValidationVO = _validationResults[i] as ValidationVO;
				if (vvo.invalid) {
					messages.push(vvo.errorMessage);
				}
			}
			
			return messages;
		}

		public function validate() : Boolean {
			var failed : Array = [];
			var lastStatus : String = _status;
			_status = VALID;
			_validationResults = [];
			
			var leni : int = _elements.length;
			var forceDispatchFail : Boolean;
			for (var i : int = 0;i < leni;i++) {
				var element : IValidatableElement = _elements[i] as IValidatableElement;
				
				var vvo : ValidationVO = new ValidationVO(element);
				_validationResults.push(vvo);
				
				var last : ValidationVO = _validationByElement[element] as ValidationVO;
				_validationByElement[element] = vvo;
				
				var validator : IValidator = correct(element);
				
				if (validator) {
					validator.validate(vvo);
				} else {
					vvo.valid = false;
					vvo.errorMessage = "No registered validator found for " + element.validationType;
					Logee.warn(vvo.errorMessage);
				}

				if (vvo.invalid) {
					failed.push(vvo);
					_status = INVALID;
				}
				
				var fsc : FormValidationEvent = new FormValidationEvent(FormValidationEvent.ELEMENT_STATUS_CHANGE);
				fsc.validation = vvo;
				
				if (!last && vvo.invalid) {
					// validation fails for the first time, dispatch status change.
					dispatchEvent(fsc);
					forceDispatchFail = true;
				} else if (last && vvo.valid != last.valid) {
					// status changed.
					dispatchEvent(fsc);
					forceDispatchFail = true;
				}
			}
			
			if (lastStatus != _status || forceDispatchFail) {
				if (_status == VALID) {
					dispatchEvent(new FormValidationEvent(FormValidationEvent.VALIDATION_SUCCESS));
				} else if (forceDispatchFail || _status == INVALID) {
					var fve : FormValidationEvent = new FormValidationEvent(FormValidationEvent.VALIDATION_FAILED);
					fve.failedValidations = failed;
					dispatchEvent(fve);
				}
			}
			
			return _status == VALID;
		}

		public function correct(inCorrectable : IValidatableElement) : IValidator {
			var validator : IValidator = _validators[inCorrectable.validationType] as IValidator;
			
			if (validator && validator is ICorrector) {
				var storeDOC : Boolean = inCorrectable.dispatchOnChange;
				inCorrectable.dispatchOnChange = false;
				inCorrectable.value = ICorrector(validator).correct(inCorrectable.value);
				inCorrectable.dispatchOnChange = storeDOC;
			}
			
			return validator;
		}

		public function getInvalidResults() : Array {
			if (!_validationResults) return [];
			
			var invalids : Array = [];
			
			var leni : int = _validationResults.length;
			for (var i : int = 0;i < leni;i++) {
				var vvo : ValidationVO = _validationResults[i] as ValidationVO;
				if (vvo.invalid) invalids.push(vvo);
			}
			
			return invalids;
		}

		public function getAllResults() : Array {
			return _validationResults;
		}
	}
}
