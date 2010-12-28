package com.epologee.navigator.integration.robotlegs {
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DisplayObjectRecipe {
		public var OfClass : Class;
		public var params : Array;
		//
		private var _product : DisplayObject;

		public function DisplayObjectRecipe(inDisplayObjectClass : Class, inParams : Array) {
			OfClass = inDisplayObjectClass;
			params = inParams;
		}

		public function get produced() : Boolean {
			return _product != null;
		}

		/**
		 * Lazily instantiates the product.
		 */
		public function get product() : DisplayObject {
			if (!_product) switch(params.length) {
					default:
					case 0:
						_product = new OfClass();
						break;
					case 1:
						_product = new OfClass(params[0]);
						break;
					case 2:
						_product = new OfClass(params[0], params[1]);
						break;
					case 3:
						_product = new OfClass(params[0], params[1], params[2]);
						break;
					case 4:
						_product = new OfClass(params[0], params[1], params[2], params[3]);
						break;
					case 5:
						_product = new OfClass(params[0], params[1], params[2], params[3], params[4]);
						break;
					case 6:
						_product = new OfClass(params[0], params[1], params[2], params[3], params[4], params[5]);
						break;
					case 7:
						_product = new OfClass(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
						break;
					case 8:
						_product = new OfClass(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
						break;
					case 9:
						_product = new OfClass(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
						break;
					case 10:
						_product = new OfClass(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9]);
				}

			return _product;
		}

		public function toString() : String {
			return "[DisplayObjectRecipe " + getQualifiedClassName(OfClass) + "]";
		}
	}
}
