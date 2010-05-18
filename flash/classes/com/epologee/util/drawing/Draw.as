package com.epologee.util.drawing {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class Draw {
		public static const CENTER:String = "CENTER";
		public static const NO_OFFSET:Point = new Point();
		
		public static function square(inCanvas : *, inSize : Number = 64, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : * {
			if (!inCanvas.graphics) return null;
			
			var g : Graphics = inCanvas.graphics;
			g.beginFill(inColor, inAlpha);
			g.drawRect(inCentered ? -inSize / 2 : 0, inCentered ? -inSize / 2 : 0, inSize, inSize);
			g.endFill();
			
			return inCanvas;
		}

		public static function rectangle(inCanvas : *, inWidth : Number = 64, inHeight : Number = 32, inColor : uint = 0xFF9900, inAlpha : Number = 1, inOffset:* = null) : * {
			if (!inCanvas.graphics) return null;
			if (inOffset == CENTER) inOffset = new Point(-inWidth / 2, inHeight / 2);
			if (!(inOffset is Point)) inOffset = NO_OFFSET;
			
			var g : Graphics = inCanvas.graphics;
			g.beginFill(inColor, inAlpha);
			g.drawRect(inOffset.x, inOffset.y, inWidth, inHeight);
			g.endFill();
			
			return inCanvas;
		}

		public static function window(inCanvas : *, inWidth : Number = 64, inHeight : Number = 32, inThickness : Number = 4, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : * {
			if (!inCanvas.graphics) return null;
			
			var g : Graphics = inCanvas.graphics;
			g.beginFill(inColor, inAlpha);
			g.drawRect(inCentered ? -inWidth / 2 : 0, inCentered ? -inHeight / 2 : 0, inWidth, inHeight);
			g.drawRect(inThickness + (inCentered ? -inWidth / 2 : 0), inThickness + (inCentered ? -inHeight / 2 : 0), inWidth - inThickness * 2, inHeight - inThickness * 2);
			g.endFill();
			
			return inCanvas;
		}

		public static function roundedRectangle(inCanvas : *, inWidth : Number = 64, inHeight : Number = 32, inCornerRadius : Number = 4, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : * {
			if (!inCanvas.graphics) return null;
			
			var g : Graphics = inCanvas.graphics;
			g.beginFill(inColor, inAlpha);
			g.drawRoundRect(inCentered ? -inWidth / 2 : 0, inCentered ? -inHeight / 2 : 0, inWidth, inHeight, inCornerRadius * 2, inCornerRadius * 2);
			g.endFill();
			
			return inCanvas;
		}

		public static function circle(inCanvas : *, inRadius : Number, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : * {
			if (!inCanvas.graphics) return null;
			
			var g : Graphics = inCanvas.graphics;
			g.beginFill(inColor, inAlpha);
			g.drawCircle(inCentered ? 0 : inRadius, inCentered ? 0 : inRadius, inRadius);
			g.endFill();
			
			return inCanvas;
		}

		public static function ellipse(inCanvas : *, inWidth : Number = 64, inHeight : Number = 32, inColor : uint = 0xFF9900, inAlpha : Number = 1, inCentered : Boolean = false) : * {
			if (!inCanvas.graphics) return null;
			
			var g : Graphics = inCanvas.graphics;
			g.beginFill(inColor, inAlpha);
			g.drawEllipse(inCentered ? 0 : inWidth, inCentered ? 0 : inHeight, inWidth, inHeight);
			g.endFill();
			
			return inCanvas;
		}

		/**
		 * Clear the graphics of an untyped object.
		 */
		public static function clear(inCanvas : *) : void {
			inCanvas.graphics.clear();
		}

		public static function lineStyle(inCanvas : Shape, inThickness : Number = 1, inColor : uint = 0x000000, inAlpha : Number = 1, inPixelHinting : Boolean = false) : void {
			inCanvas.graphics.lineStyle(inThickness, inColor, inAlpha, inPixelHinting);
		}
	}
}
