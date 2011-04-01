package com.epologee.navigator.integration.robotlegs.mapping {
	import com.epologee.development.logging.logger;
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
		public function mapViewMediator(inStatesOrPaths : *, inViewClass : Class, inMediatorClass : Class, ...inViewConstructionParams : Array) : ViewRecipe {
			if (inMediatorClass != null) {
				_mediatorMap.mapView(inViewClass, inMediatorClass);
			}

			return addRecipe(inStatesOrPaths, inViewClass, inViewConstructionParams);
		}

		/**
		 * @inheritDoc
		 */
		public function mapView(statesOrPaths : *, viewClass : Class, ...viewConstructionParams : Array) : ViewRecipe {
			return addRecipe(statesOrPaths, viewClass, viewConstructionParams);
		}

		/**
		 * @inheritDoc
		 */
		public function mapViewAs(statesOrPaths : *, viewClass : Class, mediatorClass : Class, injectViewAs : *, ...viewConstructionParams : Array) : ViewRecipe {
			if (mediatorClass != null) {
				_mediatorMap.mapView(viewClass, mediatorClass, injectViewAs);
			}

			return addRecipe(statesOrPaths, viewClass, viewConstructionParams);
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

		private function addRecipe(statesOrPaths : *, viewClass : Class, viewConstructionParams : Array) : ViewRecipe {
			var recipe : ViewRecipe = uniqueRecipeOf(viewClass, viewConstructionParams);

			var statesOrPathsList : Array = (statesOrPaths is Array) ? statesOrPaths : [statesOrPaths];
			for each (var stateOrPath : * in statesOrPathsList) {
				var stateRecipes : Array = _recipesByPath[NavigationState.make(stateOrPath).path] ||= [];
				if (stateRecipes.indexOf(recipe) < 0) {
					stateRecipes.push(recipe);
				} else {
					// ignoring duplicate
				}
			}

			return recipe;
		}

		private function handleStateRequested(event : NavigatorEvent) : void {
			for (var path:String in _recipesByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				if (event.state.contains(state)) {
					var stateRecipes : Array = _recipesByPath[path];

					if (stateRecipes) {
						for (var i : int = stateRecipes.length; --i >= 0; ) {
							var recipe : ViewRecipe = ViewRecipe(stateRecipes[i]);

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
		private function addProductToContextView(recipe : ViewRecipe) : void {
			var container : DisplayObjectContainer = recipe.parent ? recipe.parent.displayObject as DisplayObjectContainer : _contextView;

			var start : int = _recipesByLayer.indexOf(recipe);
			var leni : int = _recipesByLayer.length;
			for (var i : int = start + 1; i < leni ; i++) {
				var testRecipe : ViewRecipe = ViewRecipe(_recipesByLayer[i]);
				// If the tested recipe has it's object on the container's display list
				if (testRecipe.instantiated && testRecipe.displayObject.parent == container) {
					// add the product right below the current test's product.
					logger.debug("adding " + recipe.displayObject + " at index " + container.getChildIndex(testRecipe.object) + " to "+container);
					container.addChildAt(recipe.displayObject, container.getChildIndex(testRecipe.object));
					return;
				}
			}

			// otherwise add on top
			logger.debug("adding " + recipe.displayObject + " on top of "+container);
			container.addChild(recipe.object);
		}

		private function recipeExistsOf(viewComponentClass : Class) : Boolean {
			for each (var recipe : ViewRecipe in _recipesByLayer) {
				if (recipe.ObjectClass == viewComponentClass) return true;
			}

			return false;
		}

		private function uniqueRecipeOf(viewComponentClass : Class, constructorParams : Array) : ViewRecipe {
			for each (var recipe : ViewRecipe in _recipesByLayer) {
				if (recipe.ObjectClass == viewComponentClass) return recipe;
			}

			var newRecipe : ViewRecipe = new ViewRecipe(_injector, viewComponentClass, constructorParams);
			_recipesByLayer.push(newRecipe);
			return newRecipe;
		}
	}
}
