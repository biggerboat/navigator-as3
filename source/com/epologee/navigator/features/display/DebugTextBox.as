package com.epologee.navigator.features.display {
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugTextBox extends DebugTextField {
		public function DebugTextBox(inFontSize : Number = 12, inColor : uint = 0x000000, inBold : Boolean = false, inItalic : Object = false) {
			super("Arial", inFontSize, inColor, inBold, inItalic);
			embedFonts = false;
			
			width = 300; 
			height = 100;
			autoSize = TextFieldAutoSize.NONE;
			wordWrap = true;
		}
	}
}
