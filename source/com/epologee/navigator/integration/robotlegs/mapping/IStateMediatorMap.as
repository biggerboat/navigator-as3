package com.epologee.navigator.integration.robotlegs.mapping {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IStateMediatorMap {
		/**
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 */
		function mapState(inStatesOrPaths : *, inViewClass : Class, inMediatorClass : Class, ...inViewConstructionParams : Array) : void;

		/**
		 * Alternative mapStateView, with support for RobotLegs' injectViewAs parameter.
		 * 
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 * @param inMediatorClass The <code>IMediator</code> Class
		 * @param inInjectViewAs The explicit view Interface or Class that the mediator depends on OR an Array of such Interfaces/Classes.
		 */
		function mapStateViewAs(inStatesOrPaths : *, inViewClass : Class, inMediatorClass : Class, inInjectViewAs : *, ...inViewConstructionParams : Array) : void;

		/**
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 */
		function mapAdditionalStates(inStatesOrPaths : *, inViewClass : Class) : void;
	}
}
