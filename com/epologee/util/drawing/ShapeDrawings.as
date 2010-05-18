package com.epologee.util.drawing {
	import flash.display.Shape;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ShapeDrawings {
		public static function square(inSize : Number = 64, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : Shape {
			return Draw.square(new Shape(), inSize, inColor, inAlpha, inCentered);
		}

		public static function rectangle(inWidth : Number = 64, inHeight : Number = 32, inColor : uint = 0xFF9900, inAlpha : Number = 1, inOffset : * = null) : Shape {
			return Draw.rectangle(new Shape(), inWidth, inHeight, inColor, inAlpha, inOffset);
		}

		public static function window(inWidth : Number = 64, inHeight : Number = 32, inThickness:Number = 4, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : Shape {
			return Draw.window(new Shape(), inWidth, inHeight, inThickness, inColor, inAlpha, inCentered);
		}

		public static function roundedRectangle(inWidth : Number = 64, inHeight : Number = 32, inCornerRadius : Number = 4, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : Shape {
			return Draw.roundedRectangle(new Shape, inWidth, inHeight, inCornerRadius, inColor, inAlpha, inCentered);
		}

		public static function circle(inRadius : Number = 64, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = true) : Shape {
			return Draw.circle(new Shape(), inRadius, inColor, inAlpha, inCentered);
		}

		public static function ellipse(inWidth : Number = 64, inHeight : Number = 32, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = true) : Shape {
			return Draw.ellipse(new Shape(), inWidth, inHeight, inColor, inAlpha, inCentered);
		}
	}
}
