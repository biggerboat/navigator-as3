package com.epologee.navigator.integration.robotlegs.mapping {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IStateControllerMap {
		function mapCommand(inStateOrPath : *, inCommandClass : Class, inExactMatch : Boolean = false, inOneShot : Boolean = false) : void;

		function unmapCommand(inStateOrPath : *, inCommandClass : Class) : void;
	}
}