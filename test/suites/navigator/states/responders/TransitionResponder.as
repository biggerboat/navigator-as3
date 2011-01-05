package suites.navigator.states.responders {
	import com.epologee.time.TimeDelay;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;

	/**
	 * @author epologee
	 */
	public class TransitionResponder implements IHasStateTransition, IHasStateInitialization {
		public var isInitialized : Boolean = false;
		public var isVisible : Boolean;
		
		public function initialize() : void {
			isInitialized = true;
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			isVisible = true;
			new TimeDelay(inCallOnComplete, 500);
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			isVisible = false;
			new TimeDelay(inCallOnComplete, 500);
		}
	}
}
