package com.epologee.navigator.states {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateUpdate extends INavigationResponder {
		/**
		 * When added to the Navigator as an update responder, this method will be fired
		 * on each change of the path below the registered state (also provided via @param inRegisteredState).
		 * The first parameter is the remainder of the substraction of the @param inState and the @param inRegisteredState.
		 * You will probably want to use this parameter for you update logic.
		 * 
		 * Pseudo code example:
		 * 		
		 * 	navigator.addResponderUpdate(this, "/gallery/");
		 * 	then the state is updated to "/gallery/categoryA/244/".
		 * 	the navigator will call update state with the following arguments:
		 * 		
		 * 		updateState("/categoryA/244/", "/gallery/categoryA/244/", "/gallery/");
		 */
		function updateState(inRemainder:NavigationState, inState : NavigationState, inRegisteredState : NavigationState) : void;
	}
}
