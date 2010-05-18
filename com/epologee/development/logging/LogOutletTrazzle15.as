package com.epologee.development.logging {
	import flash.display.Stage;

	import com.nesium.logging.TrazzleLogger;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class LogOutletTrazzle15 implements ILogOutlet {
		private var _trazzle : TrazzleLogger;

		public function LogOutletTrazzle15(inStage : Stage, inTitle : String) {
			_trazzle = new TrazzleLogger();
			_trazzle.setParams(inStage, inTitle);
		}

		public function log(inMessage : String, inLevel:String) : void {
			_trazzle.log(inLevel + " " + inMessage, 2);
		}
	}
}
