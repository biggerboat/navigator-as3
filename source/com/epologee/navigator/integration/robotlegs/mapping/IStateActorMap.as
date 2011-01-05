package com.epologee.navigator.integration.robotlegs.mapping {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IStateActorMap {
		function mapStateSingleton(inStatesOrPaths : *, inActorClass : Class) : void;

		function mapStateSingletonOf(inStatesOrPaths : *, inActorClass : Class, inUseSingletonOf : Class) : void;
	}
}
