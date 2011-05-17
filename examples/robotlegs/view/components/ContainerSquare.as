package view.components {
	import model.constants.Positions;
	import view.components.BaseShape;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ContainerSquare extends BaseShape {
		public function ContainerSquare() {
			super(0xCCCCCC, Positions.SHAPE_SIZE + Positions.MARGIN_LEFT * 2);
		}
	}
}
