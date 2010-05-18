package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function fatal (inMessage:* = "") : void {
		LogInlet.log(inMessage, LogLevel.FATAL);
	}
}
