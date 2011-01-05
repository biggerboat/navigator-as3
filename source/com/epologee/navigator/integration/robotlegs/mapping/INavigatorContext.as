package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.navigator.Navigator;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface INavigatorContext {
		function get navigator() : Navigator;

		function get stateMediatorMap() : IStateMediatorMap;

		function get stateCommandMap() : IStateCommandMap;
		
		function get stateActorMap() : IStateActorMap;
	}
}
