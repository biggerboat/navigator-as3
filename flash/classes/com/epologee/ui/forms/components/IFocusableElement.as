package com.epologee.ui.forms.components {
	import flash.display.InteractiveObject;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public interface IFocusableElement {
		function get focusTarget() : InteractiveObject;
		function get focalIndex() : int;
	}
}
