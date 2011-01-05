package com.epologee.navigator.integration.robotlegs.controller {
	import com.epologee.navigator.NavigationState;

	import org.robotlegs.mvcs.Command;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class AbstractStateCommand extends Command {
		[Inject]
		public var full : NavigationState;
		[Inject(name="truncated")]
		public var truncated : NavigationState;
		
		// and then please implement your own execute() method
	}
}
