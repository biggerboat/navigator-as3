package com.epologee.ui.text {
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class FormattedTextField extends TextField {
		private var _color : uint;

		public function FormattedTextField(inFont : String, inFontSize : Number = 12, inColor : uint = 0x000000, inBold : Boolean = false, inItalic : Object = false) {
			super();
			embedFonts = true;
			width = 100;
			autoSize = TextFieldAutoSize.LEFT;
			antiAliasType = AntiAliasType.ADVANCED;
			_color = inColor;
			defaultTextFormat = new TextFormat(inFont, inFontSize, _color, inBold, inItalic);
			selectable = false;
		}
		
		public function set align(inTextFormatAlign:String) : void {
			if (styleSheet) return;

			var fmt : TextFormat = getTextFormat();
			fmt.align = inTextFormatAlign;
			setTextFormat(fmt);
			
			defaultTextFormat = fmt;
		}

		public function get align():String {
			var fmt : TextFormat = getTextFormat();
			return fmt.align;
		}

		public function set fontSize(inSize:Number) : void {
			if (styleSheet) return;

			var fmt : TextFormat = getTextFormat();
			fmt.size = inSize;
			setTextFormat(fmt);
			
			defaultTextFormat = fmt;
		}
		
		public function get fontSize():Number {
			var fmt : TextFormat = getTextFormat();
			return Number(fmt.size);
		}

		public function set bold(inBold : Boolean) : void {
			if (styleSheet) return;

			var fmt : TextFormat = getTextFormat();
			fmt.bold = inBold;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}

		public function set italic(inItalic : Boolean) : void {
			if (styleSheet) return;
			
			var fmt : TextFormat = getTextFormat();
			fmt.italic = inItalic;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}

		public function set leading(inLeading : int) : void {
			if (styleSheet) return;
			
			var fmt : TextFormat = getTextFormat();
			fmt.leading = inLeading;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}

		public function get leading() : int {
			if (styleSheet) return 0;
			
			var fmt : TextFormat = getTextFormat();
			return int(fmt.leading);
		}

		override public function set text(inText : String) : void {
			if (inText == null) {
				htmlText = "*text supplied as null object*";
				return;
			}
			
			htmlText = inText;
		}

		override public function set htmlText(inHTML : String) : void {
			multiline = inHTML.match(/\<br *\/\>/gi).length ? true : false;
			super.htmlText = inHTML;
		}
		
		public function get color() : uint {
			return _color;
		}
		
		public function set color(inColor : uint) : void {
			if (styleSheet) return;

			_color = inColor;
			
			var fmt : TextFormat = getTextFormat();
			fmt.color = inColor;
			setTextFormat(fmt);

			defaultTextFormat = fmt;
		}
	}
}
