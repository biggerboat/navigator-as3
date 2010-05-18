package com.epologee.ui.buttons {
	import flash.display.Stage;
	import flash.events.IEventDispatcher;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Extend this with other I...State interfaces for extended functionality of your button.
	 */
	public interface IHasDrawnStates extends IEventDispatcher {
		function get stage():Stage;
		function drawUpState() : void;
		function drawOverState() : void;
	}
}
