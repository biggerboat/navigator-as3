package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class LogInlet {
		private static var _loggers : Array = [];

		public static function addLogger(inLogger : ILogOutlet) : void {
			for each (var logger : ILogOutlet in _loggers) {
				if (logger == inLogger) return;
				if (typeof logger == typeof inLogger) return;
			}
			_loggers.push(inLogger);
		}

		/**
		 * Static version of the ILogger implementation.
		 */
		public static function log(inMessage : String, inLevel : String) : void {
			var leni : int = _loggers.length;
			for (var i : int = 0;i < leni;i++) {
				ILogOutlet(_loggers[i]).log(inMessage, inLevel);
			}
		}

		public static function testLogLevels() : void {
			var levels : Array = [LogLevel.DEBUG,
									LogLevel.INFO,
									LogLevel.NOTICE ,
									LogLevel.WARNING ,
									LogLevel.ERROR 	,
									LogLevel.CRITICAL,
									LogLevel.FATAL];
									
			while (levels.length) {
				var l : String = levels.shift();
				log("Testing log level "+l, l);
			}
		}
	}
}
