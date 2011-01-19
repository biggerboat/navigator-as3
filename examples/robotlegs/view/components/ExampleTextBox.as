package view.components {
	import flash.events.TextEvent;
	import model.constants.Positions;

	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.features.display.DebugTextBox;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ExampleTextBox extends DebugTextBox {
		[Inject]
		public var navigator : Navigator;
		//
		private var t : String;

		public function ExampleTextBox() {
			super();

			x = Positions.MARGIN_LEFT;
			y = Positions.MARGIN_TOP;
			width = 620;
			height = Positions.TEXT_BOX_HEIGHT;

			t = "<b>Navigator integration example for RobotLegs</b><br /><br />";
			t += "Added to this example are 4 view components with corresponding mediators; a red, green and blue square, and a black circle. By clicking the menu, you can change the navigation state. ";
			t += "You can also type in a path in the debug console. ";
			t += "The view components are added to the stage automatically, in the order you added them with stateMediatorMap.mapState()<br /><br />";
			t += "<a href='event:red'><u>Red Square</u></a> | <a href='event:green'><u>Green Square</u></a> | <a href='event:blue'><u>Blue Square</u></a> | <a href='event:black'><u>Black Circle</u></a><br /><br />";
			t += "But what you can also do is show two shapes at the same time, by using state cascading:<br /><br />";
			t += "<a href='event:red/blue'><u>Red and Blue</u></a> | <a href='event:green/black'><u>Green and Black</u></a> | <a href='event:*/black'><u>Current and Black</u></a>";

			htmlText = t;
			
			addEventListener(TextEvent.LINK, handleLinkEvent);
		}

		private function handleLinkEvent(event : TextEvent) : void {
			notice(navigator);
			navigator.requestNewState(event.text);
		}
	}
}
