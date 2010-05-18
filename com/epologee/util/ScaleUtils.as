package com.epologee.util {
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ScaleUtils {
		public static const MODE_FILL : String = "fill complete area";
		public static const MODE_FIT_HEIGHT : String = "fit height";
		public static const MODE_FIT_WIDTH : String = "fit width";
		public static const MODE_FIT_BOTH : String = "fit width and height simulatneously";

		public static function resizeToFit(inDisplayObject : DisplayObject, inFitDimensions : Point, inResizeMode : String = "fit width and height simulatneously", inSnapPixels : Boolean = false) : void {
			if (inResizeMode == MODE_FIT_HEIGHT) {
				inDisplayObject.height = inFitDimensions.y;
				inDisplayObject.scaleX = inDisplayObject.scaleY;
				return;
			} else {
				inDisplayObject.width = inFitDimensions.x;
				inDisplayObject.scaleY = inDisplayObject.scaleX;
			}
			
			switch (inResizeMode) {
				case MODE_FILL:
					if (inDisplayObject.height < inFitDimensions.y) {
						inDisplayObject.height = inFitDimensions.y;
						inDisplayObject.scaleX = inDisplayObject.scaleY;
					}
					break;
				case MODE_FIT_BOTH:
					if (inDisplayObject.height > inFitDimensions.y) {
						inDisplayObject.height = inFitDimensions.y;
						inDisplayObject.scaleX = inDisplayObject.scaleY;
					}
					break;
			}
			
			if (inSnapPixels) {
				inDisplayObject.width = Math.round(inDisplayObject.width);
				inDisplayObject.height = Math.round(inDisplayObject.height);
			}
		}	

		public static function matchDimensions(inTarget: DisplayObject, inSource : DisplayObject) : void {
			inTarget.width = inSource.width;
			inTarget.height = inSource.height;
		}
	}
}
