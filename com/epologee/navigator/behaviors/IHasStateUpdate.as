package com.epologee.navigator.behaviors {
	import com.epologee.navigator.NavigationState;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateUpdate extends INavigationResponder {
		/**
		 * When added to the Navigator as an update responder, this method will be fired
		 * on each change of the path below the registered state (also provided via @param inRegistered state).
		 * The first parameter is the remainder of the substraction/truncation of the @param inState and the @param inRegistered state.
		 * You will probably want to use this parameter for you update logic.
		 * 
		 * Pseudo code example:
		 * 		
		 * 	navigator.addResponderUpdate(this, "/gallery/");
		 * 	then the state is updated to "/gallery/categoryA/244/".
		 * 	the navigator will call update state with the following arguments:
		 * 		
		 * 		updateState("/categoryA/244/", "/gallery/categoryA/244/");
		 */
		function updateState(inTruncated:NavigationState, inFull : NavigationState) : void;
	}
}
