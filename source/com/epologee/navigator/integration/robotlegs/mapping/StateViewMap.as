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

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class StateViewMap implements IStateViewMap, IHasStateValidationOptional {
		private var _navigator : INavigator;
		private var _orderedRecipes : Array;
		private var _uniquePaths : Array;
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

			_orderedRecipes = [];
			_uniquePaths = [];
		}

		/**
		 * This validator will only process states contained by the layered states.
		 */
		public function willValidate(truncated : NavigationState, full : NavigationState) : Boolean {
			return validate(truncated, full);
		}

		public function validate(truncated : NavigationState, full : NavigationState) : Boolean {
			for each (var path : String in _uniquePaths) {
				if (NavigationState.make(path).equals(full)) return true;
			}

			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function mapViewMediator(statesOrPaths : *, viewClass : Class, mediatorClass : Class, ...viewConstructionParams : Array) : ViewRecipe {
			if (mediatorClass != null) {
				_mediatorMap.mapView(viewClass, mediatorClass, null, true, false);
			}

			return addRecipe(statesOrPaths, viewClass, viewConstructionParams);
		}

		/**
		 * @inheritDoc
		 */
		public function mapViewAs(statesOrPaths : *, viewClass : Class, mediatorClass : Class, injectViewAs : *, ...viewConstructionParams : Array) : ViewRecipe {
			if (mediatorClass != null) {
				_mediatorMap.mapView(viewClass, mediatorClass, injectViewAs, true, false);
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

		/**
		 * @inheritDoc
		 */
		public function mapView(statesOrPaths : *, viewClass : Class, ...viewConstructionParams : Array) : ViewRecipe {
			return addRecipe(statesOrPaths, viewClass, viewConstructionParams);
		}

		private function addRecipe(statesOrPaths : *, viewClass : Class, viewConstructionParams : Array) : ViewRecipe {
			var recipe : ViewRecipe = uniqueRecipeOf(viewClass, viewConstructionParams);
			if (_orderedRecipes.indexOf(recipe) < 0) _orderedRecipes.push(recipe);

			var statesOrPathsList : Array = (statesOrPaths is Array) ? statesOrPaths : [statesOrPaths];
			for each (var stateOrPath : * in statesOrPathsList) {
				var state : NavigationState = NavigationState.make(stateOrPath);
				if (_uniquePaths.indexOf(state.path) < 0) _uniquePaths.push(state.path);
				recipe.addState(state);
			}

			return recipe;
		}

		private function handleStateRequested(event : NavigatorEvent) : void {
			for each (var recipe : ViewRecipe in _orderedRecipes) {
				for each (var state : NavigationState in recipe.states) {
					if (event.state.contains(state)) {
						addProductToContextView(recipe);

						if (recipe.object is INavigationResponder) {
							_navigator.add(recipe.object, state);
						}

						var mediatorResponder : INavigationResponder = _mediatorMap.retrieveMediator(recipe.displayObject) as INavigationResponder;
						if (mediatorResponder) {
							_navigator.add(mediatorResponder, state);
						}
					}
				}
			}
		}

		/**
		 * Takes care of ordering the products in the order their recipes were added.
		 */
		private function addProductToContextView(recipe : ViewRecipe) : void {
			if (recipe.instantiated && recipe.displayObject.parent != null) {
				// recipe object is already on stage, skip the rest of this method.
				// logger.info("Recipe of " + recipe.displayObject + " is already on stage");
				return;
			}

			if (recipe.parent && !recipe.parent.instantiated) {
				// first add the parent recipe's object to the displaylist, otherwise
				// the robotlegs added_to_stage event is not triggered.
				// logger.info("First adding parent recipe");
				addProductToContextView(recipe.parent);
			}

			var container : DisplayObjectContainer;
			if (recipe.parent && recipe.parent is DisplayObjectContainer) {
				container = DisplayObjectContainer(recipe.parent.displayObject);
			} else {
				container = _contextView;
			}

			var leni : int = _orderedRecipes.length;
			for (var i : int = _orderedRecipes.indexOf(recipe) + 1; i < leni; i++) {
				var testRecipe : ViewRecipe = ViewRecipe(_orderedRecipes[i]);
				// If the tested recipe has it's object on the container's display list
				if (testRecipe.instantiated && testRecipe.displayObject.parent == container) {
					// add the product right below the current test's product.
					var index : int = container.getChildIndex(testRecipe.displayObject);
					// logger.debug("Adding " + recipe.displayObject + " to " + container + " @ " + index);
					container.addChildAt(recipe.displayObject, index);
					return;
				}
			}

			// otherwise add on top
			// logger.debug("Adding " + recipe.displayObject + " to " + container + " @ top");
			container.addChild(recipe.object);
		}

		private function recipeExistsOf(viewComponentClass : Class) : Boolean {
			for each (var recipe : ViewRecipe in _orderedRecipes) {
				if (recipe.ObjectClass == viewComponentClass) return true;
			}

			return false;
		}

		private function uniqueRecipeOf(viewComponentClass : Class, constructorParams : Array) : ViewRecipe {
			for each (var recipe : ViewRecipe in _orderedRecipes) {
				if (recipe.ObjectClass == viewComponentClass) return recipe;
			}

			var newRecipe : ViewRecipe = new ViewRecipe(_injector, viewComponentClass, constructorParams);
			return newRecipe;
		}
	}
}
