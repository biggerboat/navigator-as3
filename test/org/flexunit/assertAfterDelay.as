package org.flexunit {
	import com.epologee.time.TimeDelay;
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public function assertAfterDelay(delayMS:Number, assertionCallback:Function, ...parameters:Array) : void {
		var td : TimeDelay = new TimeDelay(assertionCallback, delayMS, parameters);
		td.catchErrors = false;
	}
}
