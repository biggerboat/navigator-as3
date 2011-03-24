package com.epologee.navigator.behaviors {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateTransition extends INavigationResponder {
		/**
		 * Called when the responder is needs to show itself.
		 * 
		 * Call @param inCallOnComplete when the transition is ready. This may be instant or asynchronous.
		 */
		function transitionIn(callOnComplete:Function):void;
		/**
		 * Called when the responder needs to hide itself.
		 * The transitionOut() is never called before a transitionIn().
		 * 
		 * Call @param inCallOnComplete when the transition is  ready. This may be instant or asynchronous.
		 */
		function transitionOut(callOnComplete:Function):void;
	}
}
