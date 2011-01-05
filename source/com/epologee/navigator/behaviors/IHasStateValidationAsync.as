package com.epologee.navigator.behaviors {
	import com.epologee.navigator.NavigationState;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * When you application does not have the knowledge over whether a state is valid instantly,
	 * you can use this interface. For example when your application navigates to /gallery/209/
	 * yet only a server knows whether image 209 actually exists, you need asynchronous validation.
	 */
	public interface IHasStateValidationAsync extends IHasStateValidation {
		/**
		 * This method is called instead of the regular validate() method, when a new state gets requested.
		 * The navigator will wait for the inCallOnPrepared function call to actually execute validate().
		 * This may happen instantly, or asynchronously.
		 * 
		 * Typically, you would store your validation data in a kind of model, which your validate() method can
		 * poll when actually validating the data.
		 */
		function prepareValidation(inTruncated : NavigationState, inFull : NavigationState, inCallOnPrepared:Function):void;
	}
}
