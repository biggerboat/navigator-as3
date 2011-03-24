package com.epologee.navigator.features.display {
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugTextBox extends DebugTextField {
		public function DebugTextBox(fontSize : Number = 12, color : uint = 0x000000, bold : Boolean = false, italic : Object = false) {
			super("Arial", fontSize, color, bold, italic);
			embedFonts = false;
			
			width = 300; 
			height = 100;
			autoSize = TextFieldAutoSize.NONE;
			wordWrap = true;
		}
	}
}
