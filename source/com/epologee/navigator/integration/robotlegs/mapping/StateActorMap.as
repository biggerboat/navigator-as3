package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.NavigatorEvent;
	import com.epologee.navigator.behaviors.INavigationResponder;

	import org.robotlegs.core.IInjector;

	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class StateActorMap implements IStateActorMap {
		private var _navigator : INavigator;
		private var _classesByPath : Dictionary;
		private var _injector : IInjector;

		public function StateActorMap(navigator : INavigator, iInjector : IInjector) {
			_navigator = navigator;
			_navigator.addEventListener(NavigatorEvent.STATE_REQUESTED, handleStateRequested);

			_injector = iInjector;

			_classesByPath = new Dictionary();
		}

		/**
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 */
		public function mapSingleton(statesOrPaths : *, actorClass : Class) : void {
			_injector.mapSingleton(actorClass);
			
			addStateClass(statesOrPaths, actorClass);			
		}

		/**
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 */
		public function mapSingletonOf(statesOrPaths : *, actorClass : Class, useSingletonOf :Class) : void {
			_injector.mapSingletonOf(actorClass, useSingletonOf);
			addStateClass(statesOrPaths, actorClass);			
		}

		private function addStateClass(statesOrPaths : *, actorClass : Class) : void {
			var statesOrPathsList : Array = (statesOrPaths is Array) ? statesOrPaths : [statesOrPaths];
			for each (var stateOrPath : * in statesOrPathsList) {
				var stateClasses : Array = _classesByPath[NavigationState.make(stateOrPath).path] ||= [];
				if (stateClasses.indexOf(actorClass) < 0) {
					stateClasses.push(actorClass);
				} else {
					// ignoring duplicate
				}
			}
		}

		private function handleStateRequested(event : NavigatorEvent) : void {
			for (var path:String in _classesByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				// actor addition is based on state containment (contrary to validation)
				if (event.state.contains(state)) {
					var stateClasses : Array = _classesByPath[path];

					if (stateClasses) {
						for (var i : int = stateClasses.length; --i >= 0; ) {
							var ActorClass : Class = stateClasses[i];
							var actorResponder : INavigationResponder = _injector.getInstance(ActorClass) as INavigationResponder;

							if (actorResponder) {
								_navigator.add(actorResponder, state);
							} else {
								throw new Error(ActorClass + " should implement INavigationResponder or subinterface thereof");
							}

							// We only add actors once, so we remove it from the list.
							stateClasses.splice(i, 1);
						}
					}
				}
			}
		}
	}
}
