package com.epologee.navigator {
	import com.epologee.navigator.behaviors.INavigationResponder;

	import flash.events.IEventDispatcher;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface INavigator extends IEventDispatcher {
		/**
		 * Adds responders to the navigator. Every responder is matched to one or more states,
		 * based on the supplied behavior. Omit the behavior paramater for auto-addition based on interface implementation.
		 * 
		 * @param responder should implement a sub-interface of INavigationResponder. Check the behaviors package for details.
		 * @param pathsOrStates - provide a string path, a typed NavigationState *or an array of both* to add the responder to.
		 * @param behavior - provide a constant from the #NavigationBehaviors enumeration or omit for #NavigationBehaviors.AUTO
		 */
		function add(responder : INavigationResponder, pathsOrStates : *, behavior : String = null) : void;
		
		/**
		 * Removes responders from the navigator per behavior or automatically. 
		 * If the responder is in the middle of a transition, it will be removed after the transition finishes.
		 *  
		 * @param responder should implement a sub-interface of INavigationResponder. Check the behaviors package for details.
		 * @param pathsOrStates - provide a string path, a typed NavigationState *or an array of both* to remove the responder from.
		 * @param behavior - provide a constant from the #NavigationBehaviors enumeration or omit for #NavigationBehaviors.AUTO
		 */
		function remove(responder : INavigationResponder, pathsOrStates : *, behavior : String = null) : void;

		/**
		 * If you want to provide shortcuts to deeper paths, like `/gallery/` pointing to `/gallery/main/1/`,
		 * the registerRedirect is the way to go. Mind that there's also a more versatile behavior interface
		 * called #IHasStateRedirection by which you can dynamically redirect the navigator in mid-validation.
		 */
		function registerRedirect(fromStateOrPath : *, toStateOrPath : *) : void;

		/**
		 * Make sure you call this method before any other request calls. Part of the request logic
		 * relies on a default state being set, this is the place to set it.
		 */
		function start(defaultStateOrPath : * = "", startStateOrPath : * = null) : void;

		/**
		 * Request a new state by providing a #NavigationState instance.
		 * If the new state is different from the current, it will be validated and granted.
		 */
		function request(stateOrPath : *) : void;

		/**
		 * You can use this to retrieve the current state of the navigator. You shouldn't need it too
		 * often if the behavior interfaces are implemented correctly, but every project has that
		 * one exceptional scenario where it's quite handy.
		 */
		function get currentState() : NavigationState;

		//
		// DEPRECATED METHODS:
		//
		// use request() instead:
		// function requestPath : *) : void;
		//
		// use .currentState accessor instead:
		// function getCurrentState() : NavigationState;
	}
}
