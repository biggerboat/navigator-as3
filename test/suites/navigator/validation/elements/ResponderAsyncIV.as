package suites.navigator.validation.elements {
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateValidationAsync;
	import com.epologee.time.TimeDelay;

	import org.osflash.signals.Signal;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ResponderAsyncIV implements IHasStateValidationAsync, IHasStateInitialization, ISignalResponder {
		public var initialized : Signal = new Signal();
		public var durationMS : Number;
		public var instantPreparation : Boolean = false;
		//
		private var _stateToValidate : NavigationState;

		public function ResponderAsyncIV(inStateToValidate : NavigationState, inAsyncDurationMS : Number = 500) {
			durationMS = inAsyncDurationMS;
			_stateToValidate = inStateToValidate;
		}

		public function removeAllSignalListeners() : void {
			initialized.removeAll();
		}

		public function initialize() : void {
			initialized.dispatch();
		}

		public function prepareValidation(inTruncated : NavigationState, inFull : NavigationState, inCallOnPrepared : Function) : void {
			if (instantPreparation) {
				inCallOnPrepared();
			} else {
				new TimeDelay(inCallOnPrepared, durationMS);
			}
		}

		public function validate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			return inTruncated.equals(_stateToValidate);
		}
	}
}
