package com.epologee.navigator.behaviors {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigationBehaviors {
		/**
		 * Will show when the state matches, will hide when it doesn't
		 */
		public static const SHOW : String = "show";
		/** 
		 * Will hide when the state matches, even if it has a show on a higher level
		 */
		public static const HIDE : String = "hide";
		/** 
		 * Will update before any show method gets called
		 */
		public static const UPDATE : String = "update";
		/** 
		 * Will swap out and in, when the state is changed
		 */ 
		public static const SWAP : String = "swap";
		/** 
		 * Will ask for validation of the state, if a state can't be validated, it is denied
		 */
		public static const VALIDATE : String = "validate";
		/** 
		 * Will try to add all behaviors, based on the interface of the responder
		 */
		public static const AUTO : String = "auto";
		/**
		 * Used for looping through when the AUTO behavior is used.
		 */
		public static const ALL_AUTO : Array = [SHOW, UPDATE, SWAP, VALIDATE];
	}
}