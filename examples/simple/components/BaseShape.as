package components {
	import flash.display.Graphics;
	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class BaseShape extends Sprite {
		protected var _color : uint;
		protected var _size : Number;
		protected var _alpha : Number;

		public function BaseShape(color : uint = 0xFF9900, size : Number = 99, alpha : Number = 1) {
			_color = color;
			_size = size;
			_alpha = alpha;
		}

		override public function get width() : Number {
			return _size;
		}

		override public function get height() : Number {
			return _size;
		}

		protected function draw() : void {
			var g : Graphics = graphics;
			g.beginFill(_color, _alpha);
			g.drawRect(0, 0, _size, _size);
			g.endFill();
		}
	}
}
