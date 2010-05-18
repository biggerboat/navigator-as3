package com.epologee.ui.forms {
	import com.epologee.logging.Logee;
	import com.epologee.ui.forms.behaviors.RadioGroupBehavior;
	import com.epologee.ui.forms.buttons.IFormButton;
	import com.epologee.ui.forms.components.FormElementEvent;
	import com.epologee.ui.forms.components.IElementGroup;
	import com.epologee.ui.forms.components.IErrorDisplay;
	import com.epologee.ui.forms.components.IErrorElement;
	import com.epologee.ui.forms.components.IFocusableElement;
	import com.epologee.ui.forms.components.IFormElement;
	import com.epologee.ui.forms.components.IRadioButtonElement;
	import com.epologee.ui.forms.components.IRadioGroupElement;
	import com.epologee.ui.forms.components.IValidatableElement;
	import com.epologee.ui.forms.validation.FormValidation;
	import com.epologee.ui.forms.validation.FormValidationEvent;
	import com.epologee.ui.forms.validation.IValidator;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class FormController extends EventDispatcher {
		protected var view : Sprite;
		//
		private var _focus : FormFocus;
		private var _validation : FormValidation;
		//
		private var _elements : Array;
		private var _buttons : Array;
		private var _groups : Array;
		//
		private var _autoValidate : Boolean;
		private var _data : Dictionary;
		private var _errorDisplays : Array;
		private var _autoSubmitElements : Object;

		public function get data() : Dictionary {
			return _data;
		}

		public function FormController() {
			_focus = new FormFocus();
			_focus.addEventListener(FormFocusEvent.SUBMIT_KEY_PRESSED, handleSubmitKeyPressed);
			_validation = new FormValidation();
			_validation.addEventListener(FormValidationEvent.ELEMENT_STATUS_CHANGE, handleValidationElementStatus);
			_validation.addEventListener(FormValidationEvent.VALIDATION_SUCCESS, handleValidationSuccess);
			_validation.addEventListener(FormValidationEvent.VALIDATION_FAILED, handleValidationFailed);
			_autoSubmitElements = [];
		}

		/**
		 * Use this to add custom validation to your form.
		 * @param inValidator: a class that implements IValidator
		 * @param inType: the string value of an element's validatorType property
		 */
		public function registerValidator(inValidator : IValidator, inType : String) : void {
			_validation.registerValidator(inValidator, inType);
		}

		/**
		 * Call the initialize method when you want the form to become active.
		 * If you need custom validation, make sure you do that first.
		 * @param inView: Pass your view sprite. Usually like _formController.initialize(this);
		 * @param inDebugMode: Will put all debug values into the form elements on runtime.
		 * @param inDisabledElements: Will disable elements listed here on initalization.
		 */
		public function initialize(inView : Sprite, inDebugMode : Boolean = false, inDisabledElements : Array = null) : void {
			view = inView;
			_focus.setStageContainer(view);
			
			checkTimelineChildren();
			
			processGroups();			
			processElements();
			addButtons();
			
			fillDefaultValues(inDebugMode);
			
			if (inDisabledElements) {
				var leni : int = inDisabledElements.length;
				for (var i : int = 0;i < leni;i++) {
					Logee.debug("initialize: " + inDisabledElements[i]);
					disableElement(inDisabledElements[i]);
				}
			}
		}

		public function enableElement(inElement : IEventDispatcher) : void {
			if (inElement is IFormElement) {
				inElement.addEventListener(FormElementEvent.VALUE_CHANGED, handleFormElementValueChanged);
			
				IFormElement(inElement).enable();

				if (inElement is IFocusableElement) {
					_focus.addElement(IFocusableElement(inElement));
				}
				
				if (inElement is IValidatableElement) {
					_validation.addElement(IValidatableElement(inElement));
				}
			} else if (inElement is IElementGroup) {
				var group : DisplayObjectContainer = DisplayObjectContainer(inElement); 
				var leni : int = group.numChildren;
				for (var i : int = 0;i < leni;i++) {
					enableElement(group.getChildAt(i));
				}
				IElementGroup(group).show();
			}		
		}

		public function disableElement(inElement : IEventDispatcher) : void {
			Logee.debug("disableElement: " + inElement);
			if (inElement is IFormElement) {
				inElement.removeEventListener(FormElementEvent.VALUE_CHANGED, handleFormElementValueChanged);
			
				IFormElement(inElement).disable();
			
				if (inElement is IFocusableElement) {
					_focus.removeElement(IFocusableElement(inElement));
				}
				
				if (inElement is IValidatableElement) {
					_validation.removeElement(IValidatableElement(inElement));
				}
			} else if (inElement is IElementGroup) {
				var group : DisplayObjectContainer = DisplayObjectContainer(inElement); 
				var leni : int = group.numChildren;
				for (var i : int = 0;i < leni;i++) {
					disableElement(group.getChildAt(i));
				}
				IElementGroup(group).hide();
			}
		}

		public function enableButtons() : void {
			var leni : int = _buttons.length;
			for (var i : int = 0;i < leni;i++) {
				var button : IFormButton = _buttons[i] as IFormButton;
				button.enable();
			}
		}

		public function disableButtons() : void {
			var leni : int = _buttons.length;
			for (var i : int = 0;i < leni;i++) {
				var button : IFormButton = _buttons[i] as IFormButton;
				button.disable();
			}
		}

		private function checkTimelineChildren() : void {
			_elements = [];
			_buttons = [];
			_groups = [];
			_errorDisplays = [];
			
			var leni : int = view.numChildren;
			for (var i : int = 0;i < leni;i++) {
				addElement(view.getChildAt(i));
			}
		}

		private function addElement(inElement : DisplayObject) : void {
			if (inElement is IFormElement) {
				_elements.push(inElement);
			} else if (inElement is IFormButton) {
				_buttons.push(inElement);
			} else if (inElement is IElementGroup) {
				_groups.push(inElement);
			} else if (inElement is IErrorDisplay) {
				_errorDisplays.push(inElement);
			}
				
			if (inElement is IRadioGroupElement) {
				new RadioGroupBehavior(IRadioGroupElement(inElement));
			}		
		}

		/**
		 * Enables the Enter key to submit the form, if the form focus is inside @param inElement
		 */
		public function autoSubmitForElement(inElement : IFocusableElement) : void {
			_autoSubmitElements.push(inElement);
		}

		private function processGroups() : void {
			var leni : int = _groups.length;
			for (var i : int = 0;i < leni;i++) {
				var group : Sprite = _groups[i] as Sprite;
				
				var lenk : int = group.numChildren;
				for (var k : int = 0;k < lenk;k++) {
					addElement(group.getChildAt(k));
				}
			}
		}

		private function processElements() : void {
			var leni : int = _elements.length;
			for (var i : int = 0;i < leni;i++) {
				var element : IFormElement = _elements[i] as IFormElement;
				enableElement(element);
			}
		}

		private function addButtons() : void {
			var leni : int = _buttons.length;
			for (var i : int = 0;i < leni;i++) {
				var button : IFormButton = _buttons[i] as IFormButton;
				
				button.addEventListener(MouseEvent.CLICK, handleClick);
			}
		}

		private function fillDefaultValues(inDebugMode : Boolean) : void {
			if (inDebugMode) {
				Logee.warn("fillDefaultValues: Turn off form debug mode before deployment!");
			}
			var leni : int = _elements.length;
			for (var i : int = 0;i < leni;i++) {
				var element : IFormElement = _elements[i] as IFormElement;
				if (inDebugMode && element.debugValue != "" && !(element is IRadioButtonElement)) {
					element.value = element.debugValue;
				} else if (element.defaultValue != null) {
					element.value = element.defaultValue;
				}
			}
		}

		private function handleSubmitKeyPressed(event : FormFocusEvent) : void {
			var leni : int = _autoSubmitElements.length;
			for (var i : int = 0;i < leni;i++) {
				if (event.focussedElement == _autoSubmitElements[i]) {
					startSubmission();
					return;
				}
			}
		}

		private function handleClick(event : MouseEvent) : void {
			startSubmission();
		}

		private function startSubmission() : void {
			if (_validation.validate()) {
				_autoValidate = false;
				
				disableButtons();
				finishSubmission();
			} else {
				_autoValidate = true;
				
				enableButtons();
				// and wait for user input
			}
		}

		private function finishSubmission() : void {
			_data = new Dictionary();
			
			var leni : int = _elements.length;
			for (var i : int = 0;i < leni;i++) {
				var element : IFormElement = _elements[i] as IFormElement;
				_data[element.dataName] = element.value;
			}
			
			dispatchEvent(new FormControllerEvent(FormControllerEvent.READY_FOR_SUBMISSION));
		}

		private function handleValidationElementStatus(event : FormValidationEvent) : void {
			var errorElement : IErrorElement = event.validation.element as IErrorElement;
			if (errorElement) {
				if (event.validation.valid) {
					errorElement.hideError();
				} else {
					errorElement.showError();
				}
			}
			
			dispatchEvent(event);
		}

		private function handleValidationSuccess(event : FormValidationEvent) : void {
			var lenk : int = _errorDisplays.length;
			for (var k : int = 0;k < lenk ;k++) {
				var display : IErrorDisplay = _errorDisplays[k] as IErrorDisplay;
				if (display) {
					display.clear();
				}
			}		

			dispatchEvent(event);
		}

		private function handleValidationFailed(event : FormValidationEvent) : void {
			var lenk : int = _errorDisplays.length;
			for (var k : int = 0;k < lenk ;k++) {
				var display : IErrorDisplay = _errorDisplays[k] as IErrorDisplay;
				if (display) {
					display.display(_validation.messages);
				}
			}		

			dispatchEvent(event);
		}

		private function handleFormElementValueChanged(event : FormElementEvent) : void {
			if (_autoValidate) {
				_validation.validate();
			} else {
				var correctable : IValidatableElement = event.target as IValidatableElement;
				
				if (correctable && correctable.autoCorrect) {
					_validation.correct(correctable);
				}
			}
			
			dispatchEvent(event);
		}
	}
}
