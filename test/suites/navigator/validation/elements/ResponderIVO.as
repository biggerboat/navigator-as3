package suites.navigator.validation.elements {
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateValidationOptional;

	import org.osflash.signals.Signal;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ResponderIVO implements IHasStateInitialization, IHasStateValidationOptional, ISignalResponder {
		public var initialized : Signal = new Signal();
		private var stateToValidate : NavigationState;
		private var stateForConfirmedValidation : NavigationState;

		public function ResponderIVO(inStateForConfirmedValidation : NavigationState, inStateToValidate : NavigationState) {
			stateForConfirmedValidation = inStateForConfirmedValidation;
			stateToValidate = inStateToValidate;
		}

		public function removeAllSignalListeners() : void {
			initialized.removeAll();
		}

		public function initialize() : void {
			initialized.dispatch();
		}

		public function willValidate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			return inTruncated.contains(stateForConfirmedValidation);
		}

		public function validate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			return inTruncated.equals(stateToValidate);
		}
	}
}
