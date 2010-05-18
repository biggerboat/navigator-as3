package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function debug (inMessage:* = "") : void {
		LogInlet.log(inMessage, LogLevel.DEBUG);
	}
}
