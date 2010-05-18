package com.epologee.util {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class AlignUtils {
		public static function alignRight(...inDisplayObjects : Array) : void {
			if (inDisplayObjects.length == 1 && inDisplayObjects[0] is Array) {
				inDisplayObjects = inDisplayObjects[0];
			}
			
			var right : int = 0;
			var next : DisplayObject;
			
			for each (next in inDisplayObjects) {
				right = Math.max(next.x + next.width, right);
			}
			
			for each (next in inDisplayObjects) {
				next.x = right - next.width;
			}
		}

		/**
		 * The first item will not be moved.
		 * The first item may be the stage.
		 */
		public static function alignCenter(...inDisplayObjects : Array) : void {
			var first : DisplayObject;
			while (!first && inDisplayObjects.length) {
				first = inDisplayObjects.shift();
			}
			
			if (!inDisplayObjects.length) return;
			
			var alignTo : Rectangle = new Rectangle();
			if (first is Stage) {
				alignTo.x = 0;
				alignTo.y = 0;
				alignTo.width = Stage(first).stageWidth;
				alignTo.height = Stage(first).stageHeight;
			} else {
				alignTo.x = first.x;
				alignTo.y = first.y;
				alignTo.width = first.width;
				alignTo.height = first.height;
			}
			
			for each (var next : DisplayObject in inDisplayObjects) {
				if (!next) continue;

				var dw : Number = (alignTo.width - next.width) / 2;
				var dh : Number = (alignTo.height - next.height) / 2;
				
				next.x = alignTo.x + dw;
				next.y = alignTo.y + dh; 
			}
		}

		public static function alignVerticalCenter(...inDisplayObjects : Array) : void {
			var first : DisplayObject;
			while (!first && inDisplayObjects.length) {
				first = inDisplayObjects.shift();
			}
			
			if (!inDisplayObjects.length) return;
			
			var alignTo : Rectangle = new Rectangle();
			if (first is Stage) {
				alignTo.y = 0;
				alignTo.height = Stage(first).stageHeight;
			} else {
				alignTo.y = first.y;
				alignTo.height = first.height;
			}
			
			for each (var next : DisplayObject in inDisplayObjects) {
				if (!next) continue;
				
				var dh : Number = (alignTo.height - next.height) / 2;
				next.y = alignTo.y + dh; 
			}
		}

		public static function spaceVertical(inMargin : Number, ...inDisplayObjects : Array) : Number {
			var first : DisplayObject;
			while (!first && inDisplayObjects.length) {
				first = inDisplayObjects.shift();
			}
			
			var y : Number = first.y + first.height;
			
			for each (var next : DisplayObject in inDisplayObjects) {
				y += inMargin;
				next.y = y;
				y += next.height; 
			}
			
			return y;
		}
	}
}
