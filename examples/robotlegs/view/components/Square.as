package view.components {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class Square extends BaseShape {
		public function Square(color : uint, name:String) {
			super(color);
			
			this.name = name;
		}
		
		override public function toString() : String {
			return "[Square "+name+"]";
		}
	}
}
