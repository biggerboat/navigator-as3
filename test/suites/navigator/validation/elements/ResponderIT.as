package suites.navigator.validation.elements {
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateTransition;

	import org.osflash.signals.Signal;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ResponderIT implements IHasStateInitialization, IHasStateTransition, ISignalResponder {
		public var visible : Boolean;
		//
		public var initialized : Signal = new Signal();
		public var transitionedIn : Signal = new Signal();
		public var transitionedOut : Signal = new Signal();
		
		public function removeAllSignalListeners() : void {
			initialized.removeAll();
			transitionedIn.removeAll();
			transitionedOut.removeAll();
		}

		public function initialize() : void {
			visible = false;
			initialized.dispatch();
		}

		public function transitionIn(inCallOnComplete : Function) : void {
			visible = true;
			inCallOnComplete();
			transitionedIn.dispatch();
		}

		public function transitionOut(inCallOnComplete : Function) : void {
			visible = false;
			inCallOnComplete();
			transitionedOut.dispatch();
		}

	}
}
