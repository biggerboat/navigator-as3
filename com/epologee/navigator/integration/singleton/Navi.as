package com.epologee.navigator.integration.singleton {
	import com.epologee.navigator.Navigator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * If you want to use the Navigator in a singleton pattern, you can use this class for accessing the instance.
	 * 
	 * The naming is short, I know, but since you'd be accessing the singleton in lots of places, I wanted to prevent
	 * having a long expression like SingletonNavigator.instance.requestState().
	 * 
	 * Therefore I had some fun with the naming, you can access the singleton instance like with:
	 * 
	 *   Navi.instance
	 *   or
	 *   Navi.gator
	 *   
	 *   and
	 *   
	 *   Navi.instance.requestNewState();
	 *   or
	 *   Navi.gator.requestNewState();
	 * 
	 * And if you want to use a subclass of the Navigator, for example SWFAddressNavigator, you should precede the
	 * very first call to '.instance' with a call like this:
	 * 
	 *   Navi.NavigatorClass = SWFAddressNavigator
	 */
	public class Navi {
		// Reassign this property to your Navigator sub class of choice.
		public static var NavigatorClass : Class = Navigator;
		//
		private static var _instance : Navigator;

		/**
		 * Use:
		 * 
		 *   Navi.instance.requestNewState("anywhere");
		 */
		public static function get instance() : Navigator {
			if (!_instance) {
				var untyped : * = new NavigatorClass();
				if (!(untyped is Navigator)) {
					throw new Error("Custom class must extend Navigator. This one does not: " + NavigatorClass);
				}
				_instance = untyped;
			}

			return _instance;
		}

		/**
		 * Alternative getter naming for gator-lovers.
		 * Plus, "gator" is even shorter than "instance"! :) 
		 */
		public static function get gator() : Navigator {
			return instance;
		}
	}
}
