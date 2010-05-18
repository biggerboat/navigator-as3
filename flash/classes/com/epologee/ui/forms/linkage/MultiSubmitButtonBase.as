package com.epologee.ui.forms.linkage {
	import com.epologee.ui.buttons.MultiStateBehavior;
	import com.epologee.ui.forms.buttons.IFormButton;

	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class MultiSubmitButtonBase extends MovieClip implements IFormButton {
		private var _msb : MultiStateBehavior;
		
		public function MultiSubmitButtonBase() {
			_msb = new MultiStateBehavior(this);
		}

		public function enable() : void {
			_msb.enable();
		}

		public function disable() : void {
			_msb.disable();
		}	
		
		override public function toString():String {
			var s:String = "";
			// s = "[ " + name + " ]:";
			return s+getQualifiedClassName(this);
		}
	}
}
