package model {
	import org.robotlegs.mvcs.Actor;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class SuperModel extends Actor implements ISuperModel {
		public function SuperModel() {
		}

		public function makeAWish() : void {
			notice("I wish for World Peace!");
		}
	}
}
