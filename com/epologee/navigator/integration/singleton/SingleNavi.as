package com.epologee.navigator.integration.singleton {
	import com.epologee.navigator.Navigator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * If you want to use the Navigator in a singleton pattern, you can use this class for accessing the instance.
	 * 
	 * The naming is weird, I know, but since you'd be accessing the singleton in lots of places, I wanted to prevent
	 * having a long expression like SingletonNavigator.instance.requestState().
	 * 
	 * Therefore I had some fun with the naming, you can access the singleton instance like with:
	 * 
	 * 		SingleNavi.gator
	 * 		
	 * 		and
	 * 		
	 * 		SingleNavi.gator.requestNewState();
	 * 
	 * And if you want to use a subclass of the Navigator, for example SWFAddressNavigator, you should precede the
	 * very first call to .gator() with a call like this:
	 * 
	 * 		SingleNavi.GatorClass = SWFAddressNavigator
	 */
	public class SingleNavi {
		// Reassign this property to your Navigator sub class of choice.
		public static var GatorClass : Class = Navigator;
		//
		private static var _instance : Navigator;

		/**
		 * Use:
		 * 
		 * 		SingleNavi.gator.requestNewState("anywhere");
		 */
		public static function get gator() : Navigator {
			if (!_instance) {
				var untyped : * = new GatorClass();
				if (!(untyped is Navigator)) {
					throw new Error("Custom class must extend Navigator. This one does not: "+GatorClass);
				}
				_instance = untyped; 
			}
			
			return _instance;
		}
	}
}
