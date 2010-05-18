package com.epologee.puremvc.navigation {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateValidation extends INavigationResponder {
		/**
		 * Synchronous validation.
		 * Will provide the new complete @param inRequestedState, including the state this
		 * responder is registered to @param inRegisteredState. Subtract the two to obtain the
		 * variable part.
		 */
		function validate(inState:NavigationState, inRegisteredState:NavigationState):String;
	}
}
