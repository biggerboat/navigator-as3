package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.navigator.NavigationState;

	import org.robotlegs.core.IInjector;

	import flash.display.DisplayObject;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ViewRecipe extends ObjectRecipe {
		public var parent : ViewRecipe = null;
		//
		private var _injector : IInjector;
		private var _states : Array = [];

		public function ViewRecipe(injector : IInjector, displayObjectClass : Class, constructorParams : Array) {
			super(displayObjectClass, constructorParams);

			_injector = injector;
		}

		public function get states() : Array {
			return _states;
		}

		public function get displayObject() : DisplayObject {
			return object as DisplayObject;
		}

		override public function get object() : * {
			if (!instantiated) {
				_injector.injectInto(super.object);
			}

			return super.object;
		}

		/**
		 * Adds a state to the states list, after checking uniqueness
		 */
		public function addState(state : NavigationState) : void {
			for each (var existing : NavigationState in _states) {
				// check for strict path equality
				// /*/something/ should not match /anything/something/, so we're not using equals();
				if (existing.path == state.path) return;
			}

			_states.push(state);
		}
	}
}
