package com.epologee.navigator.behaviors {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateInitialization extends INavigationResponder {
		/** 
		 * Just in time initialization :)
		 * 
		 * Will be called before the first call to transitionIn(), update() or validate();
		 * 
		 * Note: There may be a delay between the initialize() call and the transitionIn(),
		 * or the transitionIn() may never be called. Make sure your view component is not 
		 * already visible at the end of initialize(), use visible=false, alpha=0 or any
		 * other method of your choosing.
		 */
		function initialize() : void 
	}
}
