package com.epologee.navigator.behaviors {
	import com.epologee.navigator.NavigationState;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateSwap extends INavigationResponder {
		/**
		 * Transitions show or hide an entire object based on the state it's registered at.
		 * A Swap however, will keep the object visible and swap it's contents, when the willSwapAtState() method returns true.
		 * You should *not* assume that a willSwapAtState call is immediately followed by a swap call, because some validation may
		 * prevent the state from changing.
		 */
		function willSwapToState(truncated : NavigationState, full : NavigationState) : Boolean;

		/**
		 * This method should perform the actual swap.
		 * The swap will wait for the inSwapComplete call before the swapIn is called.
		 */
		function swapOut(swapOutComplete : Function) : void;

		/**
		 * Called with full options.
		 * Swapping in has no completion callback.
		 */
		function swapIn(truncated : NavigationState, full:NavigationState) : void;
	}
}
