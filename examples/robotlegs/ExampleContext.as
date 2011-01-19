package {
	import controller.HelloWorldCommand;
	import view.BlackCircleMediator;
	import view.BlueSquareMediator;
	import view.GreenSquareMediator;
	import view.RedSquareMediator;
	import view.components.BlackCircle;
	import view.components.BlueSquare;
	import view.components.ExampleTextBox;
	import view.components.GreenSquare;
	import view.components.RedSquare;

	import com.epologee.navigator.features.display.DebugStatusDisplay;
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
			stateCommandMap.mapState("/", HelloWorldCommand, true, true);
			
			stateMediatorMap.mapStateWithoutMediator("/", ExampleTextBox);
			
			stateMediatorMap.mapState("red", RedSquare, RedSquareMediator);
			stateMediatorMap.mapState("green", GreenSquare, GreenSquareMediator);
			stateMediatorMap.mapState("blue", BlueSquare, BlueSquareMediator);
			stateMediatorMap.mapState(["black", "*/black"], BlackCircle, BlackCircleMediator);
			
			stateMediatorMap.mapAdditionalStates("*/red", RedSquare);
			stateMediatorMap.mapAdditionalStates("*/green", GreenSquare);
			stateMediatorMap.mapAdditionalStates("*/blue", BlueSquare);
			
			
			// Navigator debug console, very nice for development. Toggle with the tilde key, "~". You can type in new states by hand!
			stateMediatorMap.mapStateWithoutMediator("/", DebugStatusDisplay, navigator);
			
			navigator.start("", "red");
			
			// Feel free to still use the super.startup dispatched event, but this demo does not.
		}
	}
}
