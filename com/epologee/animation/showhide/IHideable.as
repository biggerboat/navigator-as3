package com.epologee.animation.showhide {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHideable {
		/**
		 * @return whether the method actually performed hiding (if the instance was showing before).
		 * This is mostly used by overriding super classes, to know if they need to continue performing hiding functionality.
		 */
		function hide() : void;
	}
}
