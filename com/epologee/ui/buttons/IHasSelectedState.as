package com.epologee.ui.buttons {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IHasSelectedState extends IHasDrawnStates {

		/**
		 * Pass through to the behavior method.
		 * Use from outside of the target class.
		 */
		function select() : void;

		/**
		 * Pass through to the behavior method.
		 * Use from outside of the target class.
		 */
		function deselect() : void;

		/**
		 * Actual drawing of the selected state.
		 * Use internally.
		 */
		function drawSelected() : void;
	}
}
