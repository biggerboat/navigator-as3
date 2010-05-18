package com.epologee.ui.forms.components {
	import com.epologee.logging.Logee;

	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class FormElement extends MovieClip implements IFormElement {
		/**
		 * DATA NAME
		 */
		private var _dataName : String = "";
		/**
		 * VALUE (always type String)
		 */
		private var _value : String = "";
		/**
		 * DEBUG VALUE
		 */
		private var _debugValue : String = "";
		private var _defaultValue : String = "";
		private var _dispatchOnChange : Boolean;

		[Inspectable(name="Data Name",defaultValue="")]

		public function set dataName(inName : String) : void {
			_dataName = inName;
		}

		public function get dataName() : String {
			return _dataName;
		}

		[Inspectable(name="Value (debug)",defaultValue="")]

		public function set debugValue(inValue : String) : void {
			_debugValue = inValue;
		}

		public function get debugValue() : String {
			return _debugValue;
		}

		[Inspectable(name="Value (default)",defaultValue="")]

		public function set defaultValue(inValue : String) : void {
			_defaultValue = inValue;
		}

		public function get defaultValue() : String {
			return _defaultValue;
		}

		public function set value(inValue : String) : void {
			if (inValue != _value) {
				_value = inValue;
				if (dispatchOnChange) {
					dispatchEvent(new FormElementEvent(FormElementEvent.VALUE_CHANGED, this));
				}
			}
		}

		public function get value() : String {
			return _value;
		}

		public function enable() : void {
			blendMode = BlendMode.NORMAL;
			alpha = 1;
			mouseChildren = true;
			tabChildren = true;
		}

		public function get dispatchOnChange() : Boolean {
			return _dispatchOnChange;
		}

		public function FormElement() {
			value = defaultValue;
			dispatchOnChange = true;
			tabIndex = -1;
		}

		public function disable() : void {
			blendMode = BlendMode.LAYER;
			alpha = 0.2;
			mouseChildren = false;
			tabChildren = false;
		}

		public function set dispatchOnChange(inFlag : Boolean) : void {
			_dispatchOnChange = inFlag;
		}

		override public function toString() : String {
			var s : String = "";
			s = "[ " + dataName + " == " + value + " ]:";
			return s + getQualifiedClassName(this);
		}
	}
}
