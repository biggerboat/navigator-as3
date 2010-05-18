package com.epologee.ui.forms.linkage {
	import com.epologee.ui.forms.buttons.IFormButton;

	import flash.display.BlendMode;
	import flash.display.MovieClip;

	/**
	 * @author Eric-Paul Lecluse | epologee.com � 2009
	 */
	public class SubmitButtonBase extends MovieClip implements IFormButton {
		public function SubmitButtonBase() {
			mouseChildren = false;
			stop();
			enable();
		}
		
		public function enable() : void {
			buttonMode = true;
			super.enabled = true;
			alpha = 1;
			blendMode = BlendMode.NORMAL;
		}

		public function disable() : void {
			buttonMode = false;
			super.enabled = false;
			blendMode = BlendMode.LAYER;
			alpha = 0.5;
		}
	}
}
