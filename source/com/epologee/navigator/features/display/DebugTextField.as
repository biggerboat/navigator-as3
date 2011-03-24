package com.epologee.navigator.features.display {
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DebugTextField extends TextField {
		private var _color : uint;

		public function DebugTextField(font : String, fontSize : Number = 12, color : uint = 0x000000, bold : Boolean = false, italic : Object = false) {
			super();
			embedFonts = true;
			width = 100;
			autoSize = TextFieldAutoSize.LEFT;
			antiAliasType = AntiAliasType.ADVANCED;
			_color = color;
			defaultTextFormat = new TextFormat(font, fontSize, _color, bold, italic);
			selectable = false;
		}
		
		public function set align(textFormatAlign:String) : void {
			if (styleSheet) return;

			var fmt : TextFormat = getTextFormat();
			fmt.align = textFormatAlign;
			setTextFormat(fmt);
			
			defaultTextFormat = fmt;
		}

		public function get align():String {
			var fmt : TextFormat = getTextFormat();
			return fmt.align;
		}

		public function set fontSize(size:Number) : void {
			if (styleSheet) return;

			var fmt : TextFormat = getTextFormat();
			fmt.size = size;
			setTextFormat(fmt);
			
			defaultTextFormat = fmt;
		}
		
		public function get fontSize():Number {
			var fmt : TextFormat = getTextFormat();
			return Number(fmt.size);
		}

		public function set bold(bold : Boolean) : void {
			if (styleSheet) return;

			var fmt : TextFormat = getTextFormat();
			fmt.bold = bold;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}

		public function set italic(italic : Boolean) : void {
			if (styleSheet) return;
			
			var fmt : TextFormat = getTextFormat();
			fmt.italic = italic;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}

		public function set leading(leading : int) : void {
			if (styleSheet) return;
			
			var fmt : TextFormat = getTextFormat();
			fmt.leading = leading;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}

		public function get leading() : int {
			if (styleSheet) return 0;
			
			var fmt : TextFormat = getTextFormat();
			return int(fmt.leading);
		}

		override public function set text(value : String) : void {
			if (value == null) {
				htmlText = "*text supplied as null object*";
				return;
			}
			
			htmlText = value;
		}

		override public function set htmlText(value : String) : void {
			multiline = value.match(/\<br *\/\>/gi).length ? true : false;
			super.htmlText = value;
		}
		
		public function get color() : uint {
			return _color;
		}
		
		public function set color(color : uint) : void {
			if (styleSheet) return;

			_color = color;
			
			var fmt : TextFormat = getTextFormat();
			fmt.color = color;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}
	}
}
