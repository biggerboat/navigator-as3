package com.epologee.navigator {
	import flash.events.IEventDispatcher;

	import com.epologee.navigator.behaviors.INavigationResponder;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface INavigator extends IEventDispatcher {
		function add(responder : INavigationResponder, pathsOrStates : *, behaviors : String = null) : void;

		function registerRedirect(fromStateOrPath : *, toStateOrPath : *) : void;

		function start(defaultStateOrPath : * = "", startStateOrPath : * = null) : void;

		function request(stateOrPath : *) : void;

		function get currentState() : NavigationState;

		//
		// DEPRECATED METHODS:
		//
		/** DEPRECATED. use request() instead */
		function requestNewState(stateOrPath : *) : void;

		/** DEPRECATED. use currentState accessor instead */
		function getCurrentState() : NavigationState;
	}
}
