package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.navigator.INavigator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface INavigatorContext {
		/**
		 * Accessor for the Navigator instance mapped to INavigator
		 */
		function get navigator() : INavigator;

		/**
		 * For mapping your models or other subclasses of Actor to states.
		 */
		function get stateActorMap() : IStateActorMap;

		/**
		 * For mapping views and mediators to states.
		 */
		function get stateViewMap() : IStateViewMap;

		/**
		 * For mapping commands to states
		 */
		function get stateControllerMap() : IStateControllerMap;
	}
}
