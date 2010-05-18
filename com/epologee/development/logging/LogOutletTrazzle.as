package com.epologee.development.logging {
	import com.nesium.logging.TrazzleLogger;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class LogOutletTrazzle implements ILogOutlet {
		private var _trazzle : TrazzleLogger;

		public function LogOutletTrazzle() {
			_trazzle = new TrazzleLogger();
		}

		public function log(inMessage : String, inLevel : String) : void {
			_trazzle.log(inLevel + " " + inMessage, 2);
		}
	}
}