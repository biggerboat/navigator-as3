package components {
	import com.epologee.navigator.features.display.DebugTextBox;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ExampleTextBox extends DebugTextBox {
		private var t : String;
		public function ExampleTextBox() {
			super();
			
			width = 620;
			height = 160;
			
			t = "<b>Simple Navigator Example (no dependencies)</b><br /><br />";
			t+= "Welcome to the first example of the Navigator-AS3 library. ";
			t+= "Added to this example are 4 elements. A red, green and blue square, and a black circle. By clicking the menu, you can change the navigation state. ";
			t+= "You can also type in a path in the debug console.<br /><br />";
			t+= "<a href='event:red'><u>Red Square</u></a> | <a href='event:green'><u>Green Square</u></a> | <a href='event:blue'><u>Blue Square</u></a> | <a href='event:black'><u>Black Circle</u></a><br /><br />";
			t+= "But what you can also do is show two shapes at the same time, by using state cascading:<br /><br />";
			t+= "<a href='event:red/blue'><u>Red and Blue</u></a> | <a href='event:green/black'><u>Green and Black</u></a> | <a href='event:*/black'><u>Current and Black</u></a>";
			
			htmlText = t;
		}
	}
}
