package com.epologee.navigator.integration.robotlegs.mapping {
	import org.robotlegs.core.IInjector;
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.NavigatorEvent;
	import com.epologee.navigator.behaviors.IHasStateValidationOptional;
	import com.epologee.navigator.behaviors.INavigationResponder;
	import com.epologee.navigator.behaviors.NavigationBehaviors;

	import org.robotlegs.core.IMediatorMap;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class StateViewMap implements IStateViewMap, IHasStateValidationOptional {
		private var _navigator : Navigator;
		private var _recipesByPath : Dictionary;
		private var _recipesByLayer : Array;
		private var _mediatorMap : IMediatorMap;
		private var _contextView : DisplayObjectContainer;
		private var _injector : IInjector;

		public function StateViewMap(inNavigator : Navigator, inInjector : IInjector, inMediatorMap : IMediatorMap, inContextView : DisplayObjectContainer) {
			_navigator = inNavigator;
			_injector = inInjector;
			_mediatorMap = inMediatorMap;
			_contextView = inContextView;
			
			_navigator.addEventListener(NavigatorEvent.STATE_REQUESTED, handleStateRequested);
			_navigator.add(this, "", NavigationBehaviors.AUTO);


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
		public function mapView(inStatesOrPaths : *, inViewClass : Class, ...inViewConstructionParams : Array) : void {
			addRecipe(inStatesOrPaths, inViewClass, inViewConstructionParams);
		}

		/**
		 * @inheritDoc
		 */
		public function mapViewAs(inStatesOrPaths : *, inViewClass : Class, inMediatorClass : Class, inInjectViewAs : *, ...inViewConstructionParams : Array) : void {
			if (inMediatorClass != null) {
				_mediatorMap.mapView(inViewClass, inMediatorClass, inInjectViewAs);
			}

			addRecipe(inStatesOrPaths, inViewClass, inViewConstructionParams);
		}

		/**
		 * @inheritDoc
		 */
		public function mapAdditionalStates(inStatesOrPaths : *, inViewClass : Class) : void {
			if (recipeExistsOf(inViewClass)) {
				addRecipe(inStatesOrPaths, inViewClass, null);
			} else {
				throw new Error("mapAdditionalStates can only be called after a mapStateView call with the same view class. This one was not found: " + inViewClass);
			}
		}

		private function addRecipe(inStatesOrPaths : *, inViewClass : Class, inViewConstructionParams : Array) : void {
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
		private function addProductToContextView(inRecipe : DisplayObjectRecipe) : void {
			_injector.injectInto(inRecipe.object);
			
			var start : int = _recipesByLayer.indexOf(inRecipe);
			var leni : int = _recipesByLayer.length;
			for (var i : int = start + 1; i < leni ; i++) {
				var testRecipe : DisplayObjectRecipe = DisplayObjectRecipe(_recipesByLayer[i]);
				if (testRecipe.instantiated && testRecipe.displayObject.parent == _contextView) {
					// add the product right below the current test's product.
					_contextView.addChildAt(inRecipe.object, _contextView.getChildIndex(testRecipe.object));
					return;
				}
			}

			// otherwise add on top
			_contextView.addChild(inRecipe.object);
		}

		private function recipeExistsOf(inViewComponentClass : Class) : Boolean {
			for each (var recipe : DisplayObjectRecipe in _recipesByLayer) {
				if (recipe.OfClass == inViewComponentClass) return true;
			}

			return false;
		}

		private function uniqueRecipeOf(inViewComponentClass : Class, inConstructorParams : Array) : DisplayObjectRecipe {
			for each (var recipe : DisplayObjectRecipe in _recipesByLayer) {
				if (recipe.OfClass == inViewComponentClass) return recipe;
			}

			var newRecipe : DisplayObjectRecipe = new DisplayObjectRecipe(inViewComponentClass, inConstructorParams);
			_recipesByLayer.push(newRecipe);
			return newRecipe;
		}
	}
}
