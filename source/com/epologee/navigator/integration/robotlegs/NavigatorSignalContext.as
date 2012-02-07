package com.epologee.navigator.integration.robotlegs
{
	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.NavigatorEvent;
	import com.epologee.navigator.integration.robotlegs.mapping.INavigatorContext;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateControllerMap;
	import com.epologee.navigator.integration.robotlegs.mapping.IStateViewMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateActorMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateControllerMap;
	import com.epologee.navigator.integration.robotlegs.mapping.StateViewMap;

	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.mvcs.SignalContext;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Use RobotLegs, Signals AND the Navigator. Best of all worlds :)
	 */
	public class NavigatorSignalContext extends SignalContext implements INavigatorContext
	{
		private var _stateMediatorMap : IStateViewMap;
		private var _stateCommandMap : IStateControllerMap;
		private var _stateActorMap : IStateActorMap;
		private var _eventMap : IEventMap;

		public function NavigatorSignalContext(contextView : DisplayObjectContainer, autoStartup : Boolean = true, CustomNavigator : Class = null)
		{
			if(!injector.hasMapping(INavigator))
			{
				injector.mapSingletonOf(INavigator, CustomNavigator || Navigator);

				// Redundancy check, in case people want to Inject to Navigator
				// or their own custom class (e.g. SWFAddressNavigator)
				injector.mapValue(Navigator, injector.getInstance(INavigator));
				if(CustomNavigator && CustomNavigator != Navigator)
				{
					injector.mapValue(CustomNavigator, injector.getInstance(INavigator));
				}
			}

			_eventMap = new EventMap(eventDispatcher);
			_eventMap.mapListener(navigator, NavigatorEvent.STATE_CHANGED, dispatchEvent, NavigatorEvent);
			_eventMap.mapListener(navigator, NavigatorEvent.STATE_REQUESTED, dispatchEvent, NavigatorEvent);
			_eventMap.mapListener(navigator, NavigatorEvent.TRANSITION_STARTED, dispatchEvent, NavigatorEvent);
			_eventMap.mapListener(navigator, NavigatorEvent.TRANSITION_FINISHED, dispatchEvent, NavigatorEvent);
			_eventMap.mapListener(navigator, NavigatorEvent.TRANSITION_STATUS_UPDATED, dispatchEvent, NavigatorEvent);

			super(contextView, autoStartup);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function mapInjections() : void
		{
			super.mapInjections();
			injector.mapValue(IStateActorMap, stateActorMap);
			injector.mapValue(IStateControllerMap, stateControllerMap);
			injector.mapValue(IStateViewMap, stateViewMap);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function shutdown() : void
		{
			_eventMap.unmapListeners();
			super.shutdown();
		}

		/**
		 * @inheritDoc
		 */
		public function get navigator() : INavigator
		{
			return injector.getInstance(INavigator);
		}

		/**
		 * @inheritDoc
		 */
		public function get stateActorMap() : IStateActorMap
		{
			return _stateActorMap ||= new StateActorMap(navigator, injector);
		}

		/**
		 * @inheritDoc
		 */
		public function get stateViewMap() : IStateViewMap
		{
			return _stateMediatorMap ||= new StateViewMap(navigator, injector, mediatorMap, contextView);
		}

		/**
		 * @inheritDoc
		 */
		public function get stateControllerMap() : IStateControllerMap
		{
			return _stateCommandMap ||= new StateControllerMap(navigator, injector);
		}

		/**
		 * @inheritDoc
		 */
		public function get eventMap() : IEventMap
		{
			return _eventMap;
		}
	}
}
