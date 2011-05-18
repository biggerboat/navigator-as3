package view.components {
	import model.constants.Positions;

	import flash.display.Sprite;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class DeepNestedSquare extends Sprite {
		public function DeepNestedSquare() {
			var shape : BaseShape = new BaseShape(0xFFFFFF, Positions.SHAPE_SIZE - Positions.MARGIN_LEFT * 2);
			shape.x -= shape.width / 2;
			shape.y -= shape.height / 2;
			
			addChild(shape);
		}
	}
}
