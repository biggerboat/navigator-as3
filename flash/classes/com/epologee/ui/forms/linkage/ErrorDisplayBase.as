package com.epologee.ui.forms.linkage {
	import com.epologee.logging.Logee;
	import com.epologee.ui.forms.components.IErrorDisplay;

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ErrorDisplayBase extends MovieClip implements IErrorDisplay {
		private var _showFirstOnly : Boolean;

		[Inspectable(name="Only show first error",defaultValue=true)]
		private var _textField : TextField;

		public function set showFirstOnly(inShow : Boolean) : void {
			_showFirstOnly = inShow;
		}

		public function ErrorDisplayBase() {
			var leni:int = numChildren;
			for (var i : int = 0; i < leni; i++) {
				var possibleTextField : TextField = getChildAt(i) as TextField;
				if (possibleTextField) {
					_textField = possibleTextField;
					clear();
					break;
				}
			}
		}

		public function display(inErrors : Array) : void {
			Logee.debug("display: " + inErrors);
			
			if (!inErrors.length) {
				clear();
				return;
			}
			
			visible = true;
			_textField.text = _showFirstOnly ? inErrors[0] : inErrors.join("\n");
		}

		public function clear() : void {
			visible = false;
			_textField.text = "";
		}
		
		override public function toString():String {
			var s:String = "";
			// s = "[ " + name + " ]:";
			return s+getQualifiedClassName(this);
		}
	}
}
