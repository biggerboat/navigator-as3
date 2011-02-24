package com.epologee.navigator {
	import flash.events.IEventDispatcher;
	import com.epologee.navigator.behaviors.INavigationResponder;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * The public API of the Navigator class (and possible subclasses).
	 */
	public interface INavigator extends IEventDispatcher {
		function add(inResponder : INavigationResponder, inPathOrStates : *, inBehavior : String = null) : void;

		function remove(inResponder : INavigationResponder, inPathOrStates : *, inBehavior : String = null) : void;

		function registerRedirect(inFrom : NavigationState, inTo : NavigationState) : void;

		function start(inDefaultStateOrPath : * = "", inStartStateOrPath : * = null) : void;

		/**
		 * Request a new state by providing a #NavigationState instance.
		 * If the new state is different from the current, it will be validated and granted.
		 */
		function requestNewState(inNavigationStateOrPath : *) : void;

		function getCurrentState() : NavigationState;
	}
}
