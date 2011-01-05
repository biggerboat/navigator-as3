package com.epologee.navigator.integration.robotlegs {
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.integration.robotlegs.mapping.INavigatorContext;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateCommandMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateMediatorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateCommandMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateMediatorMap;

	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigatorContext extends Context implements INavigatorContext {
		private var _stateMediatorMap : IStateMediatorMap;
		private var _stateCommandMap : IStateCommandMap;
		private var _stateActorMap : IStateActorMap;

		public function NavigatorContext(inContextView : DisplayObjectContainer, inAutoStartUp : Boolean = true) {
			super(inContextView, inAutoStartUp);
		}

		public function get navigator() : Navigator {
			// Map a subclass of the Navigator, like SWFAddressNavigator, before constructing the context if you need to substitute it:
			// Example: injector.mapSingletonOf(Navigator, SWFAddressNavigator);
			if (!injector.hasMapping(Navigator)) {
				injector.mapSingleton(Navigator);
			}

			return injector.getInstance(Navigator);
		}

		public function get stateMediatorMap() : IStateMediatorMap {
			return _stateMediatorMap ||= new StateMediatorMap(navigator, mediatorMap, contextView);
		}

		public function get stateCommandMap() : IStateCommandMap {
			return _stateCommandMap ||= new StateCommandMap(navigator, injector);
		}

		public function get stateActorMap() : IStateActorMap {
			return _stateActorMap ||= new StateActorMap(navigator, injector);
		}
	}
}
