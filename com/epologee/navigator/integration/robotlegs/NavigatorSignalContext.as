package com.epologee.navigator.integration.robotlegs {
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

		protected function get navigationMap() : NavigationMap {
			return _navigationMap ||= new NavigationMap(injector, mediatorMap, contextView);
		}
	}
}
