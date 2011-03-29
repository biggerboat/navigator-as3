package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.NavigatorEvent;
	import com.epologee.navigator.behaviors.IHasStateValidationOptional;
	import com.epologee.navigator.behaviors.INavigationResponder;
	import com.epologee.navigator.behaviors.NavigationBehaviors;

	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class StateViewMap implements IStateViewMap, IHasStateValidationOptional {
		private var _navigator : INavigator;
		private var _recipesByPath : Dictionary;
		private var _recipesByLayer : Array;
		private var _mediatorMap : IMediatorMap;
		private var _contextView : DisplayObjectContainer;
		private var _injector : IInjector;

		public function StateViewMap(navigator : INavigator, injector : IInjector, mediatorMap : IMediatorMap, contextView : DisplayObjectContainer) {
			_navigator = navigator;
			_injector = injector;
			_mediatorMap = mediatorMap;
			_contextView = contextView;
			
			_navigator.addEventListener(NavigatorEvent.STATE_REQUESTED, handleStateRequested);
			_navigator.add(this, "", NavigationBehaviors.AUTO);


			_recipesByPath = new Dictionary();
			_recipesByLayer = [];
		}

		/**
		 * This validator will only process states contained by the layered states.
		 */
		public function willValidate(truncated : NavigationState, full : NavigationState) : Boolean {
			return validate(truncated, full);
		}

		public function validate(truncated : NavigationState, full : NavigationState) : Boolean {
			for (var path : String in _recipesByPath) {
				if (NavigationState.make(path).equals(full)) return true;
			}

			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function mapViewMediator(inStatesOrPaths : *, inViewClass : Class, inMediatorClass : Class, ...inViewConstructionParams : Array) : void {
			if (inMediatorClass != null) {
				_mediatorMap.mapView(inViewClass, inMediatorClass);
			}

			addRecipe(inStatesOrPaths, inViewClass, inViewConstructionParams);
		}

		/**
		 * @inheritDoc
		 * 
		 * FIXME: This method is called "without mediator", yet we're in a class called the "state mediator map". One of these names needs a change...
		 */
		public function mapView(statesOrPaths : *, viewClass : Class, ...viewConstructionParams : Array) : void {
			addRecipe(statesOrPaths, viewClass, viewConstructionParams);
		}

		/**
		 * @inheritDoc
		 */
		public function mapViewAs(statesOrPaths : *, viewClass : Class, mediatorClass : Class, injectViewAs : *, ...viewConstructionParams : Array) : void {
			if (mediatorClass != null) {
				_mediatorMap.mapView(viewClass, mediatorClass, injectViewAs);
			}

			addRecipe(statesOrPaths, viewClass, viewConstructionParams);
		}

		/**
		 * @inheritDoc
		 */
		public function mapAdditionalStates(statesOrPaths : *, viewClass : Class) : void {
			if (recipeExistsOf(viewClass)) {
				addRecipe(statesOrPaths, viewClass, null);
			} else {
				throw new Error("mapAdditionalStates can only be called after a mapStateView call with the same view class. This one was not found: " + viewClass);
			}
		}

		private function addRecipe(statesOrPaths : *, viewClass : Class, viewConstructionParams : Array) : void {
			var recipe : DisplayObjectRecipe = uniqueRecipeOf(viewClass, viewConstructionParams);

			var statesOrPathsList : Array = (statesOrPaths is Array) ? statesOrPaths : [statesOrPaths];
			for each (var stateOrPath : * in statesOrPathsList) {
				var stateRecipes : Array = _recipesByPath[NavigationState.make(stateOrPath).path] ||= [];
				if (stateRecipes.indexOf(recipe) < 0) {
					stateRecipes.push(recipe);
				} else {
					// ignoring duplicate
				}
			}
		}

		private function handleStateRequested(event : NavigatorEvent) : void {
			for (var path:String in _recipesByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				if (event.state.contains(state)) {
					var stateRecipes : Array = _recipesByPath[path];

					if (stateRecipes) {
						for (var i : int = stateRecipes.length; --i >= 0; ) {
							var recipe : DisplayObjectRecipe = DisplayObjectRecipe(stateRecipes[i]);

							addProductToContextView(recipe);
							if (recipe.object is INavigationResponder) {
								_navigator.add(recipe.object, state);
							}

							var mediatorResponder : INavigationResponder = _mediatorMap.retrieveMediator(recipe.displayObject) as INavigationResponder;
							if (mediatorResponder) {
								_navigator.add(mediatorResponder, state);
							}

							stateRecipes.splice(i, 1);
						}
					}
				}
			}
		}

		/**
		 * Takes care of ordering the products in the order their recipes were added.
		 */
		private function addProductToContextView(recipe : DisplayObjectRecipe) : void {
			_injector.injectInto(recipe.object);
			
			var start : int = _recipesByLayer.indexOf(recipe);
			var leni : int = _recipesByLayer.length;
			for (var i : int = start + 1; i < leni ; i++) {
				var testRecipe : DisplayObjectRecipe = DisplayObjectRecipe(_recipesByLayer[i]);
				if (testRecipe.instantiated && testRecipe.displayObject.parent == _contextView) {
					// add the product right below the current test's product.
					_contextView.addChildAt(recipe.object, _contextView.getChildIndex(testRecipe.object));
					return;
				}
			}

			// otherwise add on top
			_contextView.addChild(recipe.object);
		}

		private function recipeExistsOf(viewComponentClass : Class) : Boolean {
			for each (var recipe : DisplayObjectRecipe in _recipesByLayer) {
				if (recipe.OfClass == viewComponentClass) return true;
			}

			return false;
		}

		private function uniqueRecipeOf(viewComponentClass : Class, constructorParams : Array) : DisplayObjectRecipe {
			for each (var recipe : DisplayObjectRecipe in _recipesByLayer) {
				if (recipe.OfClass == viewComponentClass) return recipe;
			}

			var newRecipe : DisplayObjectRecipe = new DisplayObjectRecipe(viewComponentClass, constructorParams);
			_recipesByLayer.push(newRecipe);
			return newRecipe;
		}
	}
}
