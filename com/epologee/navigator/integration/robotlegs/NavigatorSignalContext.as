package com.epologee.navigator.integration.robotlegs {
	import com.epologee.navigator.Navigator;

	import org.robotlegs.mvcs.SignalContext;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigatorSignalContext extends SignalContext {
		private var _navigationMap : NavigationMap;

		public function NavigatorSignalContext(inContextView : DisplayObjectContainer, inAutoStartUp : Boolean = true) {
			super(inContextView, inAutoStartUp);
		}

		protected function get navigator() : Navigator {
			// Map a subclass of the Navigator, like SWFAddressNavigator, before constructing the context if you need to substitute it:
			// Example: injector.mapSingletonOf(Navigator, SWFAddressNavigator);
			if (!injector.hasMapping(Navigator)) {
				injector.mapSingleton(Navigator);
			}

			return injector.getInstance(Navigator);
		}

		protected function get navigationMap() : NavigationMap {
			return _navigationMap ||= new NavigationMap(navigator, mediatorMap, contextView);
		}
	}
}
