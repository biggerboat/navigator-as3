package {
	import logmeister.LogMeister;
	import logmeister.connectors.TrazzleConnector;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class RobotLegsNavigatorExample extends Sprite {
		private var context : ExampleContext;

		public function RobotLegsNavigatorExample() {
			LogMeister.addLogger(new TrazzleConnector(stage, "Example"));
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			context = new ExampleContext(this);
		}
	}
}
