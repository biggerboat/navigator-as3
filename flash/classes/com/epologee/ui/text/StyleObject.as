package com.epologee.ui.text {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Default setters for properties of the Flash StyleSheet.
	 * http://help.adobe.com/en_US/AS3LCR/Flash_10.0/flash/text/StyleSheet.html
	 * 
	 * Pass an instance of this class to style.setStyle("body", new StyleObject())
	 */
	dynamic public class StyleObject extends Object {

		public static const DISPLAY_INLINE : String = "inline";
		public static const DISPLAY_BLOCK : String = "block";
		public static const DISPLAY_NONE : String = "none";
		//
		public static const FONT_STYLE_NORMAL : String = "normal";
		public static const FONT_STYLE_ITALIC : String = "italic";
		//
		public static const FONT_WEIGHT_NORMAL : String = "normal";
		public static const FONT_WEIGHT_BOLD : String = "bold";
		//
		public static const TEXT_ALIGN_LEFT : String = "normal";
		public static const TEXT_ALIGN_CENTER : String = "center";
		public static const TEXT_ALIGN_RIGHT : String = "right";
		public static const TEXT_ALIGN_JUSTIFY : String = "justify";
		//
		public static const TEXT_DECORATION_NONE : String = "none";
		public static const TEXT_DECORATION_UNDERLINE : String = "underline";

		public function StyleObject(inFontSize:Number = NaN, inFontWeight:String = null, inFontStyle:String = null) {
			if (!isNaN(inFontSize)) {
				setFontSize(inFontSize);
			}
			
			if (inFontWeight) {
				setFontWeight(inFontWeight);
			}
			
			if (inFontStyle) {
				setFontStyle(inFontStyle);
			}
		}

		public function setColor(inColor : uint) : void { 
			this.color = inColor;
		}

		public function setDisplay(inInlineBlockNone : String) : void { 
			this.display = inInlineBlockNone;
		}

		public function setFontFamily(inFamily : String) : void { 
			this.fontFamily = inFamily;
		}

		public function setFontSize(inPixels : Number) : void { 
			this.fontSize = inPixels;
		}

		public function setFontStyle(inNormalItalic : String) : void { 
			this.fontStyle = inNormalItalic;
		}

		public function setFontWeight(inNormalBold : String) : void { 
			this.fontWeight = inNormalBold;
		}

		public function setKerning(inMSWindowsOnly : Boolean) : void { 
			this.kerning = inMSWindowsOnly;
		}

		public function setLeading(inPixels : Number) : void { 
			this.leading = inPixels;
		}

		public function setLetterSpacing(inPixels : Number) : void { 
			this.letterSpacing = inPixels;
		}

		public function setMarginLeft(inPixels : Number) : void { 
			this.marginLeft = inPixels;
		}

		public function setMarginRight(inPixels : Number) : void { 
			this.marginRight = inPixels;
		}

		public function setTextAlign(inLeftCenterRightJustify : String) : void { 
			this.textAlign = inLeftCenterRightJustify;
		}

		public function setTextDecoration(inUnderlineNone : String) : void { 
			this.textDecoration = inUnderlineNone;
		}

		public function setTextIndent(inPixels : Number) : void { 
			this.textIndent = inPixels;
		}
	}
}
