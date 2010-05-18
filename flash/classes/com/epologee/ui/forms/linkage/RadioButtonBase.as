package com.epologee.ui.forms.linkage {
	import com.epologee.ui.buttons.MultiStateBehavior;
	import com.epologee.ui.buttons.MultiStateEvent;
	import com.epologee.ui.forms.components.FormElementEvent;
	import com.epologee.ui.forms.components.IRadioButtonElement;
	import com.epologee.ui.forms.components.ValidatableErrorElement;

	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class RadioButtonBase extends ValidatableErrorElement implements IRadioButtonElement {
		private var _msb : MultiStateBehavior;
		private var _isOn : Boolean;

		public function get isOn() : Boolean {
			return _isOn;
		}

		public function RadioButtonBase() {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		public function toggle() : void {
			if (isOn) {
				turnOff();
			} else {
				turnOn();
			}
		}

		public function turnOn() : void {
			var storeDOC : Boolean = dispatchOnChange;
			dispatchOnChange = (!_isOn);
			
			_isOn = true;
			reflectValue();

			if (dispatchOnChange) {
				dispatchEvent(new FormElementEvent(FormElementEvent.ELEMENT_SELECTED, this));
			}
			
			dispatchOnChange = storeDOC;
		}

		public function turnOff() : void {
			_isOn = false;
			reflectValue();
		}

		protected function handleClick(event : MultiStateEvent) : void {
			turnOn();
		}

		private function reflectValue() : void {
			if (_msb) {
				_msb.showAlternativeState(_isOn);
			}
		}

		private function init(event : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_msb = new MultiStateBehavior(this);
			_msb.addEventListener(MultiStateEvent.CLICK, handleClick);

			if (_isOn) {
				turnOn();
			} else {
				turnOff();
			}
		}
	}
}