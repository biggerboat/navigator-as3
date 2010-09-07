package com.epologee.navigator.behaviors {
	import com.epologee.navigator.NavigationState;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateUpdate extends INavigationResponder {
		/**
		 * When added to the Navigator with the update behavior, this method will be fired
		 * on each change of the path below the registered state.
		 * The first parameter is the remainder of the substraction/truncation of the @param inState and the registered state.
		 * You will probably want to use the inTruncated.firstSegment parameter for you update logic.
		 * 
		 * Pseudo code example:
		 * 		
		 * 	navigator.add(this, "/gallery/", NavigationBehavior.UPDATE);
		 * 	
		 * 	then the state is updated to "/gallery/categoryA/244/".
		 * 	the navigator will call update state with the following arguments:
		 * 		
		 * 		updateState("/categoryA/244/", "/gallery/categoryA/244/");
		 * 		
		 * 	and inTruncated.firstSegment will render you with "categoryA",
		 * 	inTruncated.lastSegment will give you "244".
		 */
		function updateState(inTruncated:NavigationState, inFull : NavigationState) : void;
	}
}
