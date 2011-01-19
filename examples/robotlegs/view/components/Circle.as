package view.components {
	import flash.display.Graphics;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class Circle extends BaseShape {
		public function Circle(color : uint = 0xFF9900) {
			super(color);
		}

		override protected function draw() : void {
			var g : Graphics = graphics;
			g.beginFill(_color, _alpha);
			g.drawCircle(_size / 2, _size / 2, _size / 2);
			g.endFill();
		}
	}
}
