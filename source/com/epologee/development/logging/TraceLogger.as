package com.epologee.development.logging {
	/**
	 * @author Michiel van der Ros
	 * 
	 * Trace class that implements ITraceable to work with Epologee's Navigator. 
	 */
	public class TraceLogger implements ITraceable {
		public function TraceLogger() {
		}

		public function critical(inMessage : * = "") : void {
			lineTrace(inMessage);
		}

		public function debug(inMessage : * = "") : void {
			lineTrace(inMessage);
		}

		public function error(inMessage : * = "") : void {
			lineTrace(inMessage);
		}

		public function fatal(inMessage : * = "") : void {
			lineTrace(inMessage);
		}

		public function info(inMessage : * = "") : void {
			lineTrace(inMessage);
		}

		public function notice(inMessage : * = "") : void {
			lineTrace(inMessage);
		}

		public function warn(inMessage : * = "") : void {
			lineTrace(inMessage);
		}

		private function lineTrace(inMessage : *) : void {
			var prefix : String = "";
			var stack : String = new Error().getStackTrace();
			if (stack) {
				var row : String = String(stack.split("\n")[3]).replace("/", ".");
				prefix = row.match(/(?<=::).+(?=\(\))/) + " (" + row.match(/(?<=:)[0-9]+(?=\])/) + ")";
				if (inMessage) prefix += ":\t";
			}

			trace(prefix + inMessage);
		}
	}
}
