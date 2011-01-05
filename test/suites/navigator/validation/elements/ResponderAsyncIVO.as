package suites.navigator.validation.elements {
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateValidationOptionalAsync;
	import com.epologee.time.TimeDelay;

	import org.osflash.signals.Signal;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class ResponderAsyncIVO implements IHasStateValidationOptionalAsync, IHasStateInitialization, ISignalResponder {
		public var initialized : Signal = new Signal();
		public var durationMS : Number;
		public var instantPreparation : Boolean = false;
		//
		public var stateToValidate : NavigationState;
		public var stateForConfirmedValidation : NavigationState;

		public function ResponderAsyncIVO(inStateForConfirmedValidation : NavigationState, inStateToValidate : NavigationState, inAsyncDurationMS : Number = 500) {
			stateForConfirmedValidation = inStateForConfirmedValidation;
			stateToValidate = inStateToValidate;
			durationMS = inAsyncDurationMS;
		}

		public function removeAllSignalListeners() : void {
			initialized.removeAll();
		}

		public function initialize() : void {
			initialized.dispatch();
		}

		public function willValidate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			return inTruncated.contains(stateForConfirmedValidation);;
		}

		public function prepareValidation(inTruncated : NavigationState, inFull : NavigationState, inCallOnPrepared : Function) : void {
			if (instantPreparation) {
				inCallOnPrepared();
			} else {
				new TimeDelay(inCallOnPrepared, durationMS);
			}
		}

		public function validate(inTruncated : NavigationState, inFull : NavigationState) : Boolean {
			return stateToValidate.contains(inTruncated);
		}
		
		public function toString():String {
			return "[ResponderAsyncIVO "+stateForConfirmedValidation+"]";
		}
	}
}
