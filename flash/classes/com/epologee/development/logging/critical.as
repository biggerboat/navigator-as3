package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function critical(inMessage:* = "") : void {
		LogInlet.log(inMessage, LogLevel.CRITICAL);
	}
}
