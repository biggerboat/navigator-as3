package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.navigator.Navigator;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface INavigatorContext {
		function get navigator() : Navigator;

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
