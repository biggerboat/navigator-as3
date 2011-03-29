package com.epologee.navigator.integration.robotlegs {
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.integration.robotlegs.mapping.INavigatorContext;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateControllerMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateViewMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateControllerMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateViewMap;

	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigatorContext extends Context implements INavigatorContext {
		private var _stateMediatorMap : IStateViewMap;
		private var _stateCommandMap : IStateControllerMap;
		private var _stateActorMap : IStateActorMap;

		public function NavigatorContext(contextView : DisplayObjectContainer, autoStartup : Boolean = true, navigatorClass:Class = Navigator) {
			if (!injector.hasMapping(Navigator)) {
				injector.mapSingleton(Navigator);
			}

			super(contextView, autoStartup);
		}

		public function get navigator() : Navigator {
			return injector.getInstance(Navigator);
		}

		/**
		 * @inheritDoc
		 */
		public function get stateActorMap() : IStateActorMap {
			return _stateActorMap ||= new StateActorMap(navigator, injector);
		}

		/**
		 * @inheritDoc
		 */
		public function get stateViewMap() : IStateViewMap {
			return _stateMediatorMap ||= new StateViewMap(navigator, injector, mediatorMap, contextView);
		}

		/**
		 * @inheritDoc
		 */
		public function get stateControllerMap() : IStateControllerMap {
			return _stateCommandMap ||= new StateControllerMap(navigator, injector);
		}
	}
}
