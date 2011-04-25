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
		
		public function critical(message : * = "") : void {
			LogMeister.critical.apply(null,[message]);
		}

		public function debug(message : * = "") : void {
			LogMeister.debug.apply(null,[message]);
		}

		public function error(message : * = "") : void {
			LogMeister.error.apply(null,[message]);
		}

		public function fatal(message : * = "") : void {
			LogMeister.fatal.apply(null,[message]);
		}

		public function info(message : * = "") : void {
			LogMeister.info.apply(null,[message]);
		}

		public function notice(message : * = "") : void {
			LogMeister.notice.apply(null,[message]);
		}

		public function warn(message : * = "") : void {
			LogMeister.warn.apply(null,[message]);
		}
	}
}
