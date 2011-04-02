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

		function requestNewState(stateOrPath : *) : void;
		
		function get currentState() : NavigationState;
	}
}
