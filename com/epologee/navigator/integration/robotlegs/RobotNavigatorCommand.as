package com.epologee.navigator.integration.robotlegs {
	import com.epologee.navigator.Navigator;

	import org.robotlegs.mvcs.Command;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class RobotNavigatorCommand extends Command {
		[Inject]
		public var navigator : Navigator;

		public function RobotNavigatorCommand() {
			if (getQualifiedClassName(this) == getQualifiedClassName(RobotNavigatorCommand)) throw new Error("Subclass this command to use it correctly");
		}
	}
}
