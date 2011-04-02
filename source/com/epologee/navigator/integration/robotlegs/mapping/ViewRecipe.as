package com.epologee.navigator.integration.robotlegs.mapping {
	import org.robotlegs.core.IInjector;

	import flash.display.DisplayObject;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ViewRecipe extends ObjectRecipe {
		public var parent : ViewRecipe = null;
		//
		private var _injector : IInjector;

		public function ViewRecipe(injector : IInjector, displayObjectClass : Class, constructorParams : Array) {
			super(displayObjectClass, constructorParams);

			_injector = injector;
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
	}
}
