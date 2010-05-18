package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function info (inMessage:* = "") : void {
		LogInlet.log(inMessage, LogLevel.INFO);
	}
}
