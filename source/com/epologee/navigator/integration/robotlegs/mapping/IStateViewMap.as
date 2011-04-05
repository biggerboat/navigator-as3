package com.epologee.navigator.integration.robotlegs.mapping {
	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public interface IStateViewMap {
		/**
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 */
		function mapViewMediator(statesOrPaths : *, viewClass : Class, mediatorClass : Class, ...viewConstructionParams : Array) : ViewRecipe;
		
		/**
		 * Regardless of our love for RobotLegs, it is not the only way to put stuff on stage.
		 * Use this method if you just-want-to-put-a-display-object-on-the-stage in the correct layer order
		 * If your view class implements any INavigationResponder interfaces, it will be added to the navigator.
		 */
		function mapView(statesOrPaths : *, viewClass : Class, ...viewConstructionParams : Array) : ViewRecipe;

		/**
		 * Alternative mapStateView, with support for RobotLegs' injectViewAs parameter.
		 * 
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 * @param inMediatorClass The <code>IMediator</code> Class
		 * @param inInjectViewAs The explicit view Interface or Class that the mediator depends on OR an Array of such Interfaces/Classes.
		 */
		function mapViewAs(statesOrPaths : *, viewClass : Class, mediatorClass : Class, injectViewAs : *, ...viewConstructionParams : Array) : ViewRecipe;

		/**
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 */
		function mapAdditionalStates(statesOrPaths : *, viewClass : Class) : void;
	}
}
