package com.epologee.navigator.behaviors {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateInitialization extends INavigationResponder {
		/** 
		 * Just in time initialization :)
		 * 
		 * Will be called right before the first call to transitionIn(), update() or validate();
		 */
		function initialize() : void 
	}
}
