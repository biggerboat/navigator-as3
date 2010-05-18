package com.epologee.util.drawing {
	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class SpriteDrawings {
		public static function square(inSize : Number = 64, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : Sprite {
			return Draw.square(new Sprite(), inSize, inColor, inAlpha, inCentered);
		}

		public static function rectangle(inWidth : Number = 64, inHeight : Number = 32, inColor : uint = 0xFF9900, inAlpha : Number = 1, inOffset : * = null) : Sprite {
			return Draw.rectangle(new Sprite(), inWidth, inHeight, inColor, inAlpha, inOffset);
		}

		public static function window(inWidth : Number = 64, inHeight : Number = 32, inThickness : Number = 4, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : Sprite {
			return Draw.window(new Sprite(), inWidth, inHeight, inThickness, inColor, inAlpha, inCentered);
		}

		public static function roundedRectangle(inWidth : Number = 64, inHeight : Number = 32, inCornerRadius : Number = 4, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : Sprite {
			return Draw.roundedRectangle(new Sprite, inWidth, inHeight, inCornerRadius, inColor, inAlpha, inCentered);
		}

		public static function circle(inRadius : Number = 64, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = true) : Sprite {
			return Draw.circle(new Sprite(), inRadius, inColor, inAlpha, inCentered);
		}

		public static function ellipse(inWidth : Number = 64, inHeight : Number = 32, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = true) : Sprite {
			return Draw.ellipse(new Sprite(), inWidth, inHeight, inColor, inAlpha, inCentered);
		}
	}
}
