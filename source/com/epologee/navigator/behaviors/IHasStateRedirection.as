package com.epologee.navigator.behaviors {
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.behaviors.IHasStateValidation;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasStateRedirection extends IHasStateValidation {
		function redirect(truncated : NavigationState, full : NavigationState) : NavigationState;
	}
}
