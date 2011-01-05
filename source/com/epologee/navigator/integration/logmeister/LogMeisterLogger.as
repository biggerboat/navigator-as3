package com.epologee.navigator.integration.logmeister {
	import logmeister.LogMeister;
	import logmeister.NSLogMeister;

	import com.epologee.development.logging.ITraceable;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Use the awesome versatile logger called LogMeister by base42.nl 
	 * to read along the internal messages of the Navigator:
	 * https://github.com/base42/LogMeister
	 */
	public class LogMeisterLogger implements ITraceable {
		use namespace NSLogMeister;
		
		public function critical(inMessage : * = "") : void {
			LogMeister.critical(inMessage);
		}

		public function debug(inMessage : * = "") : void {
			LogMeister.debug(inMessage);
		}

		public function error(inMessage : * = "") : void {
			LogMeister.error(inMessage);
		}

		public function fatal(inMessage : * = "") : void {
			LogMeister.fatal(inMessage);
		}

		public function info(inMessage : * = "") : void {
			LogMeister.info(inMessage);
		}

		public function notice(inMessage : * = "") : void {
			LogMeister.notice(inMessage);
		}

		public function warn(inMessage : * = "") : void {
			LogMeister.warn(inMessage);
		}
	}
}
