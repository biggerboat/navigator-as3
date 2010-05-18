package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function notice(inMessage:* = "") : void {
		LogInlet.log(inMessage, LogLevel.NOTICE);
	}
}
