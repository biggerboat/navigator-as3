package com.epologee.development.logging {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * Assign any other ITraceable instance to this variable to enable your own custom logging.
	 */
	public var log : ITraceable = new LogNone();
}

import com.epologee.development.logging.ITraceable;

class LogNone implements ITraceable {
	public function critical(inMessage : *) : void {
	}

	public function debug(inMessage : *) : void {
	}

	public function error(inMessage : *) : void {
	}

	public function fatal(inMessage : *) : void {
	}

	public function info(inMessage : *) : void {
	}

	public function notice(inMessage : *) : void {
	}

	public function warn(inMessage : *) : void {
	}
}
