package com.epologee.navigator.integration.robotlegs.mapping {
	import flash.display.DisplayObject;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DisplayObjectRecipe extends ObjectRecipe {
		public function DisplayObjectRecipe(inDisplayObjectClass : Class, inParams : Array) {
			super(inDisplayObjectClass, inParams);
		}
		
		public function get displayObject():DisplayObject {
			return object as DisplayObject;
		}
	}
}
