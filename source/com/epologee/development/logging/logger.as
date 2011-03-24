package com.epologee.development.logging {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Assign any other ITraceable instance to this variable to enable your own custom logging.
	 */
	public var logger : ITraceable = new LogNone();
}
import com.epologee.development.logging.ITraceable;

class LogNone implements ITraceable {
	public function critical(message : * = "") : void {
	}

	public function debug(message : * = "") : void {
	}

	public function error(message : * = "") : void {
	}

	public function fatal(message : * = "") : void {
	}

	public function info(message : * = "") : void {
	}

	public function notice(message : * = "") : void {
	}

	public function warn(message : * = "") : void {
	}
}