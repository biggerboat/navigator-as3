package com.epologee.animation.showhide {

	import flash.events.IEventDispatcher;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Combines show and hide
	 */
	public interface IShowHide extends IShowable, IHideable, IEventDispatcher {
		function isShowing() : Boolean;
	}
}
