package com.epologee.ui.text {
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class FormattedTextBox extends FormattedTextField {
		public function FormattedTextBox(inFont : String, inFontSize : Number = 12, inColor : uint = 0x000000, inBold : Boolean = false, inItalic : Object = false) {
			super(inFont, inFontSize, inColor, inBold, inItalic);
			
			width = 300; 
			height = 100;
			autoSize = TextFieldAutoSize.NONE;
			wordWrap = true;
		}
	}
}
