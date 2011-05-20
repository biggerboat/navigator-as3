package {
	import components.Circle;
	import components.ExampleTextBox;
	import components.Square;

	import util.BaseExample;

	import com.epologee.development.logging.TraceLogger;
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.features.display.DebugConsole;

	import flash.events.TextEvent;
	import flash.text.TextField;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class SimpleNavigatorExample extends BaseExample {
		private var navigator : Navigator;
		private var display : DebugConsole;
		//
		private var intro : TextField;
		private var redSquare : Square;
		private var blueSquare : Square;
		private var greenSquare : Square;
		private var blackCircle : Circle;

		public function SimpleNavigatorExample() {
			logger = new TraceLogger();
			navigator = new Navigator();

			// Example description and menu
			intro = new ExampleTextBox();
			intro.addEventListener(TextEvent.LINK, handleTextLinkEvent);
			addRow(intro);

			// These components implement Navigator interfaces to become state responders. Look at comments in the shape classes.
			redSquare = new Square(0x990000);
			greenSquare = new Square(0x009900);
			blueSquare = new Square(0x000099);
			blackCircle = new Circle(0x000000);
			addRow(redSquare, greenSquare, blueSquare, blackCircle);

			// Navigator debug console, very nice for development. Toggle with the tilde key, "~". You can type in new states by hand!
			display = new DebugConsole(navigator);
			addChild(display);

			// Here we add the responders to the navigation states they represent.
			navigator.add(redSquare, "red");
			navigator.add(greenSquare, "green");
			navigator.add(blueSquare, "blue");
			navigator.add(blackCircle, "black");

			// We can add one responder to as many states as we like.
			navigator.add(redSquare, "*/red");
			navigator.add(greenSquare, "*/green");
			navigator.add(blueSquare, "*/blue");
			navigator.add(blackCircle, "*/black");

			// And then we decide the point at which the Navigator takes over
			navigator.start();
		}

		private function handleTextLinkEvent(event : TextEvent) : void {
			// New states are 'requested' at the Navigator. It will run a few validation tests on your requested state.
			// States that make no sense to the Navigator are denied, but if you stick to the states we added
			// responders to, we'll be perfectly fine.

			navigator.request(event.text);

			// You can influence the validation of states by adding components that implement IHasStateValidation*** interfaces.
		}
	}
}
