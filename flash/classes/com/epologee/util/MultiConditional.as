package com.epologee.util {
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Will evaluate to true if all condions are flagged as "true".
	 * Add conditions either by overloading the constructor or via addCondition().
	 */
	public class MultiConditional {
		private var _conditions : Dictionary;
		private var _callback : Function;

		public function MultiConditional(inCallback:Function, ...inConditions:*) {
			_callback = inCallback;
			_conditions = new Dictionary();
			
			var leni:int = inConditions.length;
			for (var i : int = 0; i < leni; i++) {
				addCondition(inConditions[i]);
			}
		}
		
		public function allConditionsMet() : Boolean {
			return evaluate();
		}

		public function addCondition(inIdentifier:*) : void {
			_conditions[inIdentifier] = false;
		}

		public function meetCondition(inIdentifier:*, inAutoCallback:Boolean = true) : void {
			if (_conditions[inIdentifier] == null) return;
			_conditions[inIdentifier] = true;
			
			if (inAutoCallback && evaluate() && _callback is Function) {
				_callback.apply();
			}
		}

		public function evaluate() : Boolean {
			for each (var condition : * in _conditions) {
				if (!condition) return false;		
			}
			
			return true;
		}
	}
}
