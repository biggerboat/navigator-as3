package {
	import controller.HelloWorldCommand;

	import view.BlueSquareMediator;
	import view.ContainerSquareMediator;
	import view.DeepNestedSquareMediator;
	import view.GreenSquareMediator;
	import view.NestedSquareMediator;
	import view.RedSquareMediator;
	import view.WhiteCircleMediator;
	import view.components.BlueSquare;
	import view.components.ContainerSquare;
	import view.components.DeepNestedSquare;
	import view.components.ExampleTextBox;
	import view.components.FlexDebugConsole;
	import view.components.GreenSquare;
	import view.components.NestedSquare;
	import view.components.RedSquare;
	import view.components.WhiteCircle;

	import com.epologee.navigator.integration.robotlegs.NavigatorContext;
	import com.epologee.navigator.integration.robotlegs.mapping.ViewRecipe;
	import com.epologee.navigator.integration.swfaddress.SWFAddressNavigator;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Paul Tondeur
	 */
	public class FlexExampleContext extends NavigatorContext {
		public function FlexExampleContext(inContextView : DisplayObjectContainer) {
			super(inContextView, true, SWFAddressNavigator);
		}

		override public function startup() : void {
			// Commands are triggered when the navigator enters the corresponding state
			stateControllerMap.mapCommand("/", HelloWorldCommand, true, true);

			// A simple view component mapped to a state needs no mediator
			stateViewMap.mapView("/", ExampleTextBox);

			// But if a component and mediator form a pair, we use this syntax
			stateViewMap.mapViewMediator("red", RedSquare, RedSquareMediator);

			// By calling mapView on existing mappings, we can add extra states
			stateViewMap.mapView("*/red", RedSquare);

			// You can add states one by one, or as an array
			// Wildcard '*' segments in states will match any segment in a requested state.
			stateViewMap.mapViewMediator(["green", "*/green"], GreenSquare, GreenSquareMediator);
			stateViewMap.mapViewMediator(["blue", "*/blue"], BlueSquare, BlueSquareMediator);
			stateViewMap.mapViewMediator(["white", "*/white"], WhiteCircle, WhiteCircleMediator);

			// By using a mapping's parent property, you can setup nested view components
			var container : ViewRecipe = stateViewMap.mapViewMediator("move", ContainerSquare, ContainerSquareMediator);
			var nested : ViewRecipe = stateViewMap.mapViewMediator("move/nested", NestedSquare, NestedSquareMediator);
			nested.parent = container;
			stateViewMap.mapViewMediator("move/nested/deep", DeepNestedSquare, DeepNestedSquareMediator).parent = nested;

			// Navigator debug console, very nice for development. Toggle with the tilde key, "~". You can type in new states by hand!
			stateViewMap.mapView("/", FlexDebugConsole);

			// Finally, start navigating
			navigator.start("", "red");

			// Feel free to still use the super.startup dispatched event, but this demo does not.
		}
	}
}