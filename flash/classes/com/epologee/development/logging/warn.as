package com.epologee.development.logging {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function warn(inMessage:* = "") : void {
		LogInlet.log(inMessage, LogLevel.WARNING);
	}
}
