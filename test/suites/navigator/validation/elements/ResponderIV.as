package suites.navigator.validation.elements {
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateValidation;

	import org.osflash.signals.Signal;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ResponderIV implements IHasStateInitialization, IHasStateValidation, ISignalResponder {
		public var initialized : Signal = new Signal();
		private var stateToValidate : NavigationState;

		public function ResponderIV(inStateToValidate : NavigationState) {
			stateToValidate = inStateToValidate;
		}

		public function removeAllSignalListeners() : void {
			initialized.removeAll();
		}

		public function initialize() : void {
			initialized.dispatch();
		}

		public function validate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			return inTruncated.equals(stateToValidate);
		}
	}
}
