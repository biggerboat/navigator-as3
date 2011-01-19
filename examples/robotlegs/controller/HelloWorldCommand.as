package controller {
	import com.epologee.navigator.integration.robotlegs.controller.AbstractStateCommand;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class HelloWorldCommand extends AbstractStateCommand {
		override public function execute() : void {
			notice("Hello World! We now have access to the current state: " + truncated);
		}
	}
}