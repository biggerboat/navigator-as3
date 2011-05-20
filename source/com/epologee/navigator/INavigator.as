package com.epologee.navigator {
	import com.epologee.navigator.behaviors.INavigationResponder;

	import flash.events.IEventDispatcher;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface INavigator extends IEventDispatcher {
		function add(responder : INavigationResponder, pathsOrStates : *, behaviors : String = null) : void;
		
		function remove(responder : INavigationResponder, pathsOrStates : *, behaviors : String = null) : void;

		function registerRedirect(fromStateOrPath : *, toStateOrPath : *) : void;

		function start(defaultStateOrPath : * = "", startStateOrPath : * = null) : void;

		function request(stateOrPath : *) : void;

		function get currentState() : NavigationState;

		//
		// DEPRECATED METHODS:
		//
		// use request() instead:
		// function requestNewState(stateOrPath : *) : void;
		//
		// use .currentState accessor instead:
		// function getCurrentState() : NavigationState;
	}
}
