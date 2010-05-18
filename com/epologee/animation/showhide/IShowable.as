package com.epologee.animation.showhide {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IShowable {
		/**
		 * @return whether the method actually performed showing (if the instance was hidden before)
		 * This is mostly used by overriding super classes, to know if they need to continue performing showing functionality.
		 */
		function show() : void;
	}
}
