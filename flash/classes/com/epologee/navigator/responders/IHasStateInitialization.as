package com.epologee.navigator.responders {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateInitialization extends INavigationResponder {
		/** 
		 * Will be called right before the first call to transitionIn(), update() or validate();
		 */
		function initialize() : void 
	}
}
