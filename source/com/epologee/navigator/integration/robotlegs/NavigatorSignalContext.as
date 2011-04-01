package com.epologee.navigator.integration.robotlegs {
	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.integration.robotlegs.mapping.INavigatorContext;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateControllerMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateViewMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateControllerMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateViewMap;

	import org.robotlegs.mvcs.SignalContext;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Use RobotLegs, Signals AND the Navigator. Best of all worlds :)
	 */
	public class NavigatorSignalContext extends SignalContext implements INavigatorContext {
		private var _stateMediatorMap : IStateViewMap;
		private var _stateCommandMap : IStateControllerMap;
		private var _stateActorMap : IStateActorMap;

		public function NavigatorSignalContext(contextView : DisplayObjectContainer, autoStartup : Boolean = true, navigatorClass:Class = null) {
			if (!injector.hasMapping(INavigator)) {
				injector.mapSingletonOf(INavigator, navigatorClass || Navigator);
			}

			super(contextView, autoStartup);
		}

		public function get navigator() : INavigator {
			return injector.getInstance(INavigator);
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
