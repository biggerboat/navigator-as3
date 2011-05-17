package {
	import com.epologee.navigator.integration.swfaddress.SWFAddressNavigator;
	import com.epologee.navigator.integration.robotlegs.mapping.ViewRecipe;
	import view.NestedSquareMediator;
	import view.components.NestedSquare;
	import controller.HelloWorldCommand;

	import view.BlackCircleMediator;
	import view.BlueSquareMediator;
	import view.ContainerSquareMediator;
	import view.GreenSquareMediator;
	import view.RedSquareMediator;
	import view.components.BlackCircle;
	import view.components.BlueSquare;
	import view.components.ContainerSquare;
	import view.components.ExampleTextBox;
	import view.components.GreenSquare;
	import view.components.RedSquare;

	import com.epologee.navigator.features.display.DebugConsole;
	import com.epologee.navigator.integration.robotlegs.NavigatorContext;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ExampleContext extends NavigatorContext {
		public function ExampleContext(inContextView : DisplayObjectContainer) {
			super(inContextView, true, SWFAddressNavigator);
		}

		override public function startup() : void {
			// Commands are triggered when the navigator enters the corresponding state
			stateControllerMap.mapCommand("/", HelloWorldCommand, true, true);
			
			// A simple view component mapped to a state needs no mediator
			stateViewMap.mapView("/", ExampleTextBox);
			
			// But if a component and mediator form a pair, we use this syntax 
			stateViewMap.mapViewMediator("red", RedSquare, RedSquareMediator);
			stateViewMap.mapViewMediator("green", GreenSquare, GreenSquareMediator);
			stateViewMap.mapViewMediator("blue", BlueSquare, BlueSquareMediator);
			
			// You can add states one by one, or as an array
			stateViewMap.mapViewMediator(["black", "*/black"], BlackCircle, BlackCircleMediator);

			// By using a mapping's parent property, you can setup nested view components
			var container : ViewRecipe = stateViewMap.mapViewMediator("move", ContainerSquare, ContainerSquareMediator);
			stateViewMap.mapViewMediator("move/nested", NestedSquare, NestedSquareMediator).parent = container;

			// By calling mapView on existing mappings, we can add extra states 			
			stateViewMap.mapView("*/red", RedSquare);
			stateViewMap.mapView("*/green", GreenSquare);
			stateViewMap.mapView("*/blue", BlueSquare);
			
			// Navigator debug console, very nice for development. Toggle with the tilde key, "~". You can type in new states by hand!
			stateViewMap.mapView("/", DebugConsole, navigator);
			
			// Finally, start navigating
			navigator.start("", "red");
			
			// Feel free to still use the super.startup dispatched event, but this demo does not.
		}
	}
}
