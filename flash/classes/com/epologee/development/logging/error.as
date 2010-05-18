package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function error (inMessage:* = "") : void {
		LogInlet.log(inMessage, LogLevel.ERROR);
	}
}
