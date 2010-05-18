package com.epologee.ui.forms.linkage {
	import com.epologee.ui.buttons.MultiStateBehavior;
	import com.epologee.ui.buttons.MultiStateEvent;
	import com.epologee.ui.forms.components.ValidatableErrorElement;

	import flash.events.Event;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class CheckboxBase extends ValidatableErrorElement {
		// Flash library linkage: com.epologee.ui.forms.linkage.CheckboxBase
		/**
		 * VALUE WHEN TURNED ON
		 */
		private var _valueOn : String = "yes";		
		/**
		 * VALUE WHEN TURNED OFF
		 */
		private var _valueOff : String = "no";
		private var _msb : MultiStateBehavior;
		private var _isOn : Boolean;

		[Inspectable(name="Value when on",defaultValue="yes")]

		public function set valueOn(inValue : String) : void {
			_valueOn = inValue;
		}

		public function get valueOn() : String {
			return _valueOn;
		}	

		[Inspectable(name="Value when off",defaultValue="no")]

		public function set valueOff(inValue : String) : void {
			_valueOff = inValue;
		}

		public function get valueOff() : String {
			return _valueOff;
		}

		public function get isOn() : Boolean {
			return _isOn;
		}

		public function CheckboxBase() {
			super();
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
			value = _valueOn;
		}

		public function turnOff() : void {
			value = _valueOff;
			reflectValue();
		}

		override public function set value(inValue : String) : void {
			super.value = inValue;
			reflectValue();
		}

		protected function handleClick(event : MultiStateEvent) : void {
			toggle();
		}

		private function reflectValue() : void {
			_isOn = (value == _valueOn);
			if (_msb) {
				_msb.showAlternativeState(value == _valueOn);
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
