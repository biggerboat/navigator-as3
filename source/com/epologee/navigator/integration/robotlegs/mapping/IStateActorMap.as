package com.epologee.navigator.integration.robotlegs.mapping {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IStateActorMap {
		function mapSingleton(inStatesOrPaths : *, inActorClass : Class) : void;

		function mapSingletonOf(inStatesOrPaths : *, inActorClass : Class, inUseSingletonOf : Class) : void;
	}
}
