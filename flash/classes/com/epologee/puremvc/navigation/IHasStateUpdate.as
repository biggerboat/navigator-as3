package com.epologee.puremvc.navigation {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateUpdate extends INavigationResponder {
		/**
		 * The state is updated with the complete path in @param inState. 
		 * By providing the state the responder is registered to @param inRegisteredState, you can
		 * subtract the two to obtain only the part that is of interest.
		 */
		function updateState(inState : NavigationState, inRegisteredState : NavigationState) : void;
	}
}
