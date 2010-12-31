package com.epologee.navigator.integration.robotlegs {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;
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
	public class NavigationMap implements IHasStateValidationOptional {
		private var _navigator : Navigator;
		private var _recipesByPath : Dictionary;
		private var _recipesByLayer : Array;
		private var _mediatorMap : IMediatorMap;
		private var _contextView : DisplayObjectContainer;

		public function NavigationMap(inNavigator:Navigator, inMediatorMap : IMediatorMap, inContextView : DisplayObjectContainer) {
			_navigator = inNavigator;
			_navigator.addEventListener(NavigatorEvent.STATE_CHANGED, handleStateChanged);
			_navigator.add(this, "", NavigationBehaviors.AUTO);

			_mediatorMap = inMediatorMap;
			_contextView = inContextView;

			_recipesByPath = new Dictionary();
			_recipesByLayer = [];
		}

		/**
		 * This validator will only process states contained by the layered states.
		 */
		public function willValidate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			return validate(inTruncated, inFull);
		}

		public function validate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			for (var path : String in _recipesByPath) {
				if (NavigationState.make(path).equals(inFull)) return true;
			}

			return false;
		}

		/**
		 * @param inStateOrPath can be one of three types. A string containing a path, a NavigationState object, or an array of those mixed.
		 */
		public function mapState(inStatesOrPaths : *, inViewClass : Class, inMediatorClass : Class = null, ...inViewConstructionParams : Array) : void {
			if (inMediatorClass != null) {
				_mediatorMap.mapView(inViewClass, inMediatorClass);
			}

			var recipe : DisplayObjectRecipe = uniqueRecipeOf(inViewClass, inViewConstructionParams);

			var statesOrPaths : Array = (inStatesOrPaths is Array) ? inStatesOrPaths : [inStatesOrPaths];
			for each (var stateOrPath : * in statesOrPaths) {
				var stateRecipes : Array = _recipesByPath[NavigationState.make(stateOrPath).path] ||= [];
				if (stateRecipes.indexOf(recipe) < 0) {
					stateRecipes.push(recipe);
				} else {
					// ignoring duplicate
				}
			}
		}

		private function handleStateChanged(event : NavigatorEvent) : void {
			for (var path:String in _recipesByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				if (event.state.contains(state)) {
					var stateRecipes : Array = _recipesByPath[path];
					logger.notice(event.state + " --> " + stateRecipes);

					if (stateRecipes) {
						for each (var recipe : DisplayObjectRecipe in stateRecipes) {
							if (!recipe.product.parent) {
								addProductToContextView(recipe);
							}

							var mediatorResponder : INavigationResponder = _mediatorMap.retrieveMediator(recipe.product) as INavigationResponder;
							if (mediatorResponder) {
								_navigator.add(mediatorResponder, event.state);
							}
						}
					}
				}
			}
		}

		/**
		 * Takes care of ordering the products in the order their recipes were added.
		 */
		private function addProductToContextView(inRecipe : DisplayObjectRecipe) : void {
			var start : int = _recipesByLayer.indexOf(inRecipe);
			var leni : int = _recipesByLayer.length;
			for (var i : int = start + 1; i < leni ; i++) {
				var testRecipe : DisplayObjectRecipe = _recipesByLayer[i] as DisplayObjectRecipe;
				if (testRecipe.produced && testRecipe.product.parent == _contextView) {
					// add the product right below the current test's product.
					_contextView.addChildAt(inRecipe.product, _contextView.getChildIndex(testRecipe.product));
					logger.info("Added at index: " + inRecipe);
					return;
				}
			}

			// otherwise add on top
			_contextView.addChild(inRecipe.product);
			logger.info("Added regularly");
		}

		private function uniqueRecipeOf(inViewComponentClass : Class, inConstructorParams : Array) : DisplayObjectRecipe {
			for each (var recipe : DisplayObjectRecipe in _recipesByLayer) {
				if (recipe.OfClass == inViewComponentClass) return recipe;
			}

			var newRecipe : DisplayObjectRecipe = new DisplayObjectRecipe(inViewComponentClass, inConstructorParams);
			_recipesByLayer.push(newRecipe);
			logger.notice("Recipe count (by layer): " + _recipesByLayer.length);
			return newRecipe;
		}
	}
}
