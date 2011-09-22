package util {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class BaseExample extends Sprite {
		public var pixelSnapping : Boolean = false;
		//
		private var _spacing : Point;
		private var _origin : Point;
		private var _offset : Point;

		public function BaseExample(inOriginX : Number = 10, inOriginY : Number = 10, inSpacingX : Number = 10, inSpacingY : Number = 10) {
			_spacing = new Point(inSpacingX, inSpacingY);
			_origin = new Point(inOriginX, inOriginY);
			_offset = new Point(0, 0);

			if (stage) {
				setupStage();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, setupStage);
			}
		}

		private function setupStage(...ignoreParameters) : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		public function addRow(...inRowElements : Array) : void {
			addRowAt(inRowElements);
		}

		public function addRowBehind(...inRowElements : Array) : void {
			addRowAt(inRowElements, 0);
		}

		private function addRowAt(inRowElements : Array, inDepth : Number = NaN) : void {
			var height : Number = 0;

			_offset.x = 0;

			for each (var obj : DisplayObject in inRowElements) {
				obj.x = nextX;
				obj.y = nextY;
				if (isNaN(inDepth)) {
					addChild(obj);
				} else {
					addChildAt(obj, inDepth);
				}
				height = Math.max(obj.height, height);

				_offset.x += obj.width + _spacing.x;
			}

			_offset.x = 0;
			_offset.y += height + _spacing.y;
		}

		public function reset(inOriginX : Number = NaN, inOriginY : Number = NaN, inSpacingX : Number = NaN, inSpacingY : Number = NaN) : void {
			_origin.x = isNaN(inOriginX) ? _origin.x : inOriginX;
			_origin.y = isNaN(inOriginY) ? _origin.y : inOriginY;

			_spacing.x = isNaN(inSpacingX) ? _spacing.x : inSpacingX;
			_spacing.y = isNaN(inSpacingY) ? _spacing.y : inSpacingY;

			_offset.x = 0;
			_offset.y = 0;
		}

		public function get spacingX() : Number {
			return _spacing.x;
		}

		public function set spacingX(inPixels : Number) : void {
			_spacing.x = inPixels;
		}

		public function get spacingY() : Number {
			return _spacing.y;
		}

		public function set spacingY(inPixels : Number) : void {
			_spacing.y = inPixels;
		}

		public function get nextX() : Number {
			if (pixelSnapping) return Math.round(_origin.x + _offset.x);
			return _origin.x + _offset.x;
		}

		public function get nextY() : Number {
			if (pixelSnapping) return Math.round(_origin.y + _offset.y);
			return _origin.y + _offset.y;
		}
	}
}
