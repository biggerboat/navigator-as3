package {
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
			// This would be the appropriate place to enable SWFAddress
			// injector.mapSingletonOf(Navigator, SWFAddressNavigator);

			super(inContextView);
		}

		override public function startup() : void {
			stateControllerMap.mapCommand("/", HelloWorldCommand, true, true);
			
			stateViewMap.mapView("/", ExampleTextBox);
			
			stateViewMap.mapViewMediator("red", RedSquare, RedSquareMediator);
			stateViewMap.mapViewMediator("green", GreenSquare, GreenSquareMediator);
			stateViewMap.mapViewMediator("blue", BlueSquare, BlueSquareMediator);
			stateViewMap.mapViewMediator(["black", "*/black"], BlackCircle, BlackCircleMediator);

			// By using a mapping's parent property, you can setup nested view components
			var container : ViewRecipe = stateViewMap.mapViewMediator("move", ContainerSquare, ContainerSquareMediator);
			stateViewMap.mapViewMediator("move/nested", NestedSquare, NestedSquareMediator).parent = container;
			
			stateViewMap.mapView("*/red", RedSquare);
			stateViewMap.mapView("*/green", GreenSquare);
			stateViewMap.mapView("*/blue", BlueSquare);
			
			
			// Navigator debug console, very nice for development. Toggle with the tilde key, "~". You can type in new states by hand!
			stateViewMap.mapView("/", DebugConsole, navigator);
			
			navigator.start("", "red");
			
			// Feel free to still use the super.startup dispatched event, but this demo does not.
		}
	}
}
