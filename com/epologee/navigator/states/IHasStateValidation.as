package com.epologee.navigator.states {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateValidation extends INavigationResponder {
		/**
		 * Synchronous validation.
		 * Will provide the result of subtracting the registered state from the requested (inFull) state to give you the inTruncated state.
		 */
		function validate(inTruncated:NavigationState, inFull : NavigationState):String;
	}
}
