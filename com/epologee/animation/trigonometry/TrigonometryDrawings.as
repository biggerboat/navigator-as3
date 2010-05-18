package com.epologee.animation.trigonometry {
	import flash.display.Graphics;
	import flash.geom.Point;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TrigonometryDrawings {
		public static function connect(inGraphics:Graphics, inA : Point, inB : Point, inAlpha : Number = 1, inColor : uint = 0, inThickness : Number = 1) : void {
			inGraphics.lineStyle(inThickness, inColor, inAlpha);
			inGraphics.moveTo(inA.x, inA.y);
			inGraphics.lineTo(inB.x, inB.y);
		}

		public static function draw(inGraphics:Graphics, inP : Point, inAlpha : Number = 1, inColor : uint = 0) : void {
			inGraphics.beginFill(inColor, inAlpha);
			inGraphics.drawCircle(inP.x, inP.y, 2);
			inGraphics.endFill();
		}
	}
}
