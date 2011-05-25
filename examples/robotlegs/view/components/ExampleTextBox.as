package view.components {
	import model.constants.Positions;

	import com.epologee.navigator.INavigator;
	import com.epologee.navigator.features.display.DebugTextBox;

	import flash.events.TextEvent;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ExampleTextBox extends DebugTextBox {
		[Inject]
		public var navigator : INavigator;
		//
		private var t : String;

		public function ExampleTextBox() {
			super(12, 0xFFFFFF);

			x = Positions.MARGIN_LEFT;
			y = Positions.MARGIN_TOP;
			width = 620;
			height = Positions.TEXT_BOX_HEIGHT;

			t = "<b>Navigator integration example for RobotLegs</b><br /><br />";
			t += "<font color='#999999'>Added to this example are 4 view components with corresponding mediators; a red, green and blue square, and a white circle. By clicking the menu, you can change the navigation state. ";
			t += "You can also type in a path in the debug console. ";
			t += "The view components are added to the stage automatically, in the order you added the mappings.</font><br /><br />";
			t += "<a href='event:red'><u>Red Square</u></a> | <a href='event:green'><u>Green Square</u></a> | <a href='event:blue'><u>Blue Square</u></a> | <a href='event:white'><u>White Circle</u></a><br /><br />";
			t += "<font color='#999999'>But what you can also do is show two shapes at the same time, by using state cascading:</font><br /><br />";
			t += "<a href='event:green/white'><u>Green and White</u></a> | <a href='event:red/blue'><u>Red and Blue</u></a> | <a href='event:*/white'><u>Current and White</u></a><br /><br />";
			t += "<font color='#999999'>Lastly, if you want view components to be nested, you can, by using a mapped view recipe's parent property:</font><br /><br />";
			t += "<a href='event:move'><u>Moving Container</u></a> | <a href='event:move/nested'><u>Nested Square</u></a> | <a href='event:move/nested/deep'><u>Deeply Nested Square</u></a>";

			htmlText = t;
			
			addEventListener(TextEvent.LINK, handleLinkEvent);
		}

		private function handleLinkEvent(event : TextEvent) : void {
			notice(navigator);
			navigator.request(event.text);
		}
	}
}
