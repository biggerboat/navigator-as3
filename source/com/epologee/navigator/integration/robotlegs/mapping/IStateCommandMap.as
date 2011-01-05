package com.epologee.navigator.integration.robotlegs.mapping {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IStateCommandMap {
		function mapState(inStateOrPath : *, inCommandClass : Class, inExactMatch : Boolean = false, inOneShot : Boolean = false) : void;

		function unmapStateCommand(inStateOrPath : *, inCommandClass : Class) : void;
	}
}