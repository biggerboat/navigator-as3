package com.epologee.navigator.responders {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateTransition extends INavigationResponder {
		/**
		 * Called when the responder is needs to show itself.
		 * 
		 * Call @param inCallOnComplete when the transition is ready. This may be instant or asynchronous.
		 */
		function transitionIn(inCallOnComplete:Function):void;
		/**
		 * Called when the responder needs to hide itself.
		 * The transitionOut() is never called before a transitionIn().
		 * 
		 * Call @param inCallOnComplete when the transition is  ready. This may be instant or asynchronous.
		 */
		function transitionOut(inCallOnComplete:Function):void;
	}
}
