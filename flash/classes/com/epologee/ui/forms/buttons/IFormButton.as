package com.epologee.ui.forms.buttons {
	import flash.events.IEventDispatcher;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IFormButton extends IEventDispatcher {		
		function enable() : void;

		function disable() : void;
	}
}
