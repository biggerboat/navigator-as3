package com.epologee.security {
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 * 
	 * This class can be used to protect important user values (scores, answers, etc) from
	 * memory injection hacking.
	 */
	public class AntiMemoryInjectionNumber {
		private var _value : Number;
		private var _injection : Number;
		
		public function AntiMemoryInjectionNumber() {
			_value = 0;
			_injection = 0;
		}

		public function get value() : Number {
			return _value - _injection;
		}

		public function set value(inValue : Number) : void {
			_injection = Math.round(Math.random() * 100000);
			_value = inValue + _injection;
		}
		
		public function toString():String {
			return "[Number "+value.toString()+" ]";
		}
	}
}