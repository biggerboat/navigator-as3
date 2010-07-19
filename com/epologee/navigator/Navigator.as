package com.epologee.navigator {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.states.IHasStateInitialization;
	import com.epologee.navigator.states.IHasStateTransition;
	import com.epologee.navigator.states.IHasStateUpdate;
	import com.epologee.navigator.states.IHasStateValidation;
	import com.epologee.navigator.states.INavigationResponder;
	import com.epologee.navigator.states.NavigationState;
	import com.epologee.navigator.transition.TransitionCompleteDelegate;
	import com.epologee.navigator.transition.TransitionStatus;
	import com.epologee.navigator.transition.transition;
	import com.epologee.navigator.validation.ValidationResult;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * The Navigator class is the base of an application flow management system that revolves around "Navigation States".
	 * Where the NavigationState is nothing but a wrapper around a regular path variable like "a/nice/path",
	 * the Navigator keeps track of responding classes (responders) that need to respond to changes to the application's current NavigationState.
	 * 
	 * All responders implement a subclass of INavigationResponder. The subclass' features define the capabilities of
	 * the provided responder and how the Navigator will communicate with them.
	 * 
	 * Responders may be added to transition in or out when the current state matches theirs. 
	 * For example, if an IHasStateTransition responder is added to listen to the state with path "portfolio/gallery" it will also
	 * become or stay visible when a state with the path "portfolio/gallery/information" is activated.
	 * 
	 * Because the Navigator keeps track of what responders are visible and which ones need to become visible,
	 * the transitionIn() and transitionOut() calls will not be called if the responder is already showing or already hidden.
	 * 
	 * Use the IHasStateUpdate interface in conjuction with the #addUpdateResponder method to enable variable paths to the system.
	 * For example "portfolio/gallery/1" all the way to "portfolio/gallery/999" may be caught by a single IHasStateUpdate responder.
	 * In order to validate the requested state, an IHasStateUpdate responder is usually in the company of an IHasStateValidation responder.
	 * This is a custom validation class of your own design to check whether the requested path is correct, something that will
	 * come in handy when you use the SWFAddressNavigator subclass of this Navigator.
	 */
	public class Navigator extends EventDispatcher {
		protected var _current : NavigationState;
		protected var _defaultState : NavigationState;
		//
		private var _respondersToValidateByPath : Dictionary;
		private var _respondersToUpdateByPath : Dictionary;
		private var _respondersToShowByPath : Dictionary;
		private var _respondersToHideByPath : Dictionary;
		private var _statusByResponder : Dictionary;
		private var _disappearingResponders : Array;
		private var _disappearingAsynchronously : Boolean;

		public function Navigator() {
			_respondersToValidateByPath = new Dictionary();
			_respondersToUpdateByPath = new Dictionary();
			_respondersToShowByPath = new Dictionary();
			_respondersToHideByPath = new Dictionary();
			_statusByResponder = new Dictionary();
		}

		public function start(inDefaultState : NavigationState, inStartState : NavigationState = null) : void {
			_defaultState = inDefaultState;
			
			if (inStartState) {
				requestNewState(inStartState);
			} else {
				grantRequest(_defaultState);
			}
		}

		/**
		 * Any responder added to the "show" list will receive transitionIn() and transitionOut() calls
		 * when the path they're registered to activates or deactivates. Any path's segments are used
		 * hierarchically, so if a responder should show on /gallery/, it will also show on /gallery/help/
		 * 
		 * If you want to hide a responder on a deeper level, use the #addResponderHide method.
		 */
		public function addShow(inResponder : IHasStateTransition, inPath : String) : void {
			if (!inResponder) throw new Error("addResponderShow: responder is null");
			
			var path : String = new NavigationState(inPath).path;
			
			// retrieve or create the list of responders to show for the current path:
			var showList : Array = _respondersToShowByPath[path] = _respondersToShowByPath[path] ? _respondersToShowByPath[path] : [];
			showList.push(inResponder);
			
			// If there is no status yet, set the initial status to UNINITIALIZED:			
			_statusByResponder[inResponder] = _statusByResponder[inResponder] ? _statusByResponder[inResponder] : TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		public function addHide(inResponder : IHasStateTransition, inPath : String) : void {
			if (!inResponder) throw new Error("addResponderHide: responder is null");

			var path : String = new NavigationState(inPath).path;
			
			// retrieve or create the list of responders to show for the current path:
			var hideList : Array = _respondersToHideByPath[path] = _respondersToHideByPath[path] ? _respondersToHideByPath[path] : [];
			hideList.push(inResponder);
			
			// If there is no status yet, set the initial status to UNINITIALIZED:			
			_statusByResponder[inResponder] = _statusByResponder[inResponder] ? _statusByResponder[inResponder] : TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		public function addUpdate(inResponder : IHasStateUpdate, inPath : String) : void {
			if (!inResponder) throw new Error("addResponderUpdate: responder is null");
			
			var path : String = new NavigationState(inPath).path;
						
			// retrieve or create the list of responders to update for the current path:
			var updateList : Array = _respondersToUpdateByPath[path] = _respondersToUpdateByPath[path] ? _respondersToUpdateByPath[path] : [];
			updateList.push(inResponder);

			// If there is no status yet, set the initial status to UNINITIALIZED:			
			_statusByResponder[inResponder] = _statusByResponder[inResponder] ? _statusByResponder[inResponder] : TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		public function addValidate(inResponder : IHasStateValidation, inPath : String) : void {
			if (!inResponder) throw new Error("addResponderValidate: responder is null");

			var path : String = new NavigationState(inPath).path;
						
			// retrieve or create the list of responders to update for the current path:
			var validateList : Array = _respondersToValidateByPath[path] = _respondersToValidateByPath[path] ? _respondersToValidateByPath[path] : [];
			validateList.push(inResponder);

			// If there is no status yet, set the initial status to UNINITIALIZED:			
			_statusByResponder[inResponder] = _statusByResponder[inResponder] ? _statusByResponder[inResponder] : TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		public function removeShow(inResponder : IHasStateTransition, inPath : String) : void {
			if (!inResponder) throw new Error("removeResponderShow: responder is null");
			
			var path : String = new NavigationState(inPath).path;
						
			// retrieve the list of responders to show for the current path:
			var showList : Array = _respondersToShowByPath[path];
			if (!showList) {
				throw new Error("removeResponderShow: path not found" + path);
				return;
			}
			
			// remove the element off the list.
			// by iterating in reverse, we can use the Array().splice() method
			for (var i : int = showList.length;--i >= 0;) {
				if (showList[i] == inResponder) {
					showList.splice(i, 1);
				}
			}
			
			if (!showList.length) {
				delete _respondersToShowByPath[path];
			}

			// The responder might still exist on other paths. Either check all paths,
			// or just leave the transition status be for now... 
			// _statusByResponder[inResponder] = TransitionStatus.HIDDEN;
		}

		/**
		 * Use this method when you want to pass in a simple string.
		 * If you already have a #NavigationState object, use the regular requestNewState() method.
		 */
		public function requestNewStateByPath(inPath : String) : void {
			requestNewState(new NavigationState(inPath));
		}

		/**
		 * Request a new state by providing a #NavigationState instance.
		 * If the new state is different from the current, it will be validated and granted.
		 */
		public function requestNewState(inNavigationState : NavigationState) : void {
			logger.debug("inNavigationState: " + inNavigationState);
			
			if (_current && _current.path == inNavigationState.path) {
				logger.info("Already at current state: " + inNavigationState);
				return;
			}
			
			if (inNavigationState.path == _defaultState.path) {
				// Exact match on default state bypasses validation.
				//				notice("matches default state: " + inNavigationState);
				grantRequest(_defaultState);
			} else if (validateState(inNavigationState)) {
				// Any other state needs to be validated.
				//				notice("validated: " + inNavigationState + " with current: " + _current);
				grantRequest(inNavigationState);
			} else if (validateWildcards(inNavigationState)) {
				// Validation passed after wildcard masking.
				//				notice("validated: " + inNavigationState + " masked by current: " + _current);
				grantRequest(inNavigationState.mask(_current));
			} else if (_current) {
				// If validation fails, the notifyStateChange() is called with the current state as a parameter,
				// mainly for subclasses to respond to the blocked navigation (e.g. SWFAddress). 
				//				notice("reverting to current from: " + inNavigationState);
				notifyStateChange(_current);
				return;
			} else if (inNavigationState.hasWildcard()) {
				throw new Error("Check wildcard masking: " + inNavigationState);
			} else {
				throw new Error("First request is invalid: " + inNavigationState);
			}
		}

		public function getStatus(inResponder : IHasStateTransition) : int {
			return _statusByResponder[inResponder];
		}

		public function getKnownPaths() : Array {
			var list : Object = {};
			
			var path : String;
			for (path in _respondersToShowByPath) {
				list[new NavigationState(path).path] = true;
			}
			
			var known : Array = [];
			for (path in list) {
				known.push(path);
			}
			
			known.sort();
			return known;
		}

		public function getCurrentPath() : String {
			if (!_current) return "uninitialized";
			return _current.path;
		}

		public function getCurrentState() : NavigationState {
			// not returning the _current instance for reference reasons.
			return new NavigationState(_current.path);
		}

		transition function notifyComplete(inResponder : IHasStateTransition, inStatus : int) : void {
			_statusByResponder[inResponder] = inStatus;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));

			if (_disappearingAsynchronously && inStatus == TransitionStatus.HIDDEN) {
				var index : int = _disappearingResponders.indexOf(inResponder);
				if (index >= 0) {
					_disappearingResponders.splice(index, 1);
				
					if (!_disappearingResponders.length) {
						performUpdates();
					} else {
						logger.notice("waiting for " + _disappearingResponders.length + " responders to disappear");
					}
				}
			}
		}

		protected function notifyStateChange(inNewState : NavigationState) : void {
			// Do call the super.notifyStateChange() when overriding.
			if (inNewState != _current) {
				dispatchEvent(new NavigatorEvent(NavigatorEvent.STATE_CHANGED, null));
			}
		}

		protected function grantRequest(inNavigationState : NavigationState) : void {
			_current = inNavigationState;
			
			notifyStateChange(_current);

			_disappearingAsynchronously = false;
			_disappearingResponders = startTransitionOut(); 
			
			if (_disappearingResponders.length) {
				_disappearingAsynchronously = true;
			} else {
				performUpdates();	
			}
		}

		private function validateWildcards(inNavigationState : NavigationState) : Boolean {
			if (inNavigationState.hasWildcard()) {
				// run by regular validation.
				return validateState(inNavigationState.mask(_current));
			}
			
			return false;
		}

		/**
		 * Validation is done in two steps.
		 * 
		 * Firstly, the @param inNavigationState is checked against all registered
		 * state paths in the _respondersToShowByPath list. If that already results in a
		 * valid path, it will grant the request.
		 * 
		 * Secondly, if not already granted, it will continue to look for existing validators in the _respondersToValidateByPath.
		 * If found, will call those and have the grant rely on the external validators.
		 */
		private function validateState(inNavigationState : NavigationState) : Boolean {
			var state : NavigationState;
			var path : String;
			
			// check to see if there are still wildcards left
			if (inNavigationState.hasWildcard()) {
				// throw new Error("validateState: Requested states may not contain wildcards " + NavigationState.WILDCARD);
				return false;
			}
			
			if (inNavigationState.equals(_defaultState)) {
				return true;
			}
			
			var direct : Boolean = false;
            
            // This first loop will check hard wiring of states to transition responders in the show list.
			for (path in _respondersToShowByPath) {
				state = new NavigationState(path);
                
				if (state.equals(inNavigationState)) {
					//                    info("Validation passed based on transition responder.");
					direct = true;
				}
			}
            
			var foundValidators : Boolean = false;
			for (path in _respondersToValidateByPath) {
				// create a state object for comparison:
				state = new NavigationState(path);
                            
				if (inNavigationState.containsState(state)) {
					var remainder : NavigationState = inNavigationState.subtract(state);
					foundValidators = true;
                    
					// the lookup path is contained by the new state.
					var list : Array = _respondersToValidateByPath[path];
                                
					initializeIfNeccessary(list);
                    
                    // check for existing validators.
					for each (var responder : INavigationResponder in list) {
						var validator : IHasStateValidation = responder as IHasStateValidation;
						if (validator.validate(remainder, inNavigationState, state) == ValidationResult.FAIL) {
							logger.warn("Validation failed based on validation responder: " + validator);
							return false;
						}
					}
				}
			}
            
			if (foundValidators) {
				//                info("Validation passed validation responder(s)");
				return true;
			}
            
			if (!direct) {
				logger.warn("Validation failed. No validators or transitions matched the requested " + inNavigationState);
			}
            
			return direct;
		}

		private function startTransitionOut() : Array {
			var toShow : Array = getRespondersToShow();
			
			
			var waitFor : Array = [];
			
			for (var key:* in _statusByResponder) {
				var responder : IHasStateTransition = key as IHasStateTransition;
				 
				if (toShow.indexOf(responder) < 0) {

					// if the responder is not already hidden or disappearing, trigger the transitionOut:
					if (TransitionStatus.HIDDEN < _statusByResponder[responder] && _statusByResponder[responder] < TransitionStatus.DISAPPEARING) {
						_statusByResponder[responder] = TransitionStatus.DISAPPEARING;
						waitFor.push(responder);
						
						use namespace transition;
						responder.transitionOut(new TransitionCompleteDelegate(responder, TransitionStatus.HIDDEN, this).call);
					} else {
						// already hidden or hiding
					}
				}
			}
			

			// loop backwards so we can splice elements off the array while in the loop.
			for (var i : int = waitFor.length;--i >= 0;) {
				if (_statusByResponder[waitFor[i]] == TransitionStatus.HIDDEN) {
					waitFor.splice(i, 1);
				}
			}
			
			return waitFor;
		}

		private function performUpdates() : void {
			_disappearingAsynchronously = false;
			for (var path:String in _respondersToUpdateByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);
							
				if (_current.containsState(state)) {
					// the lookup path is contained by the new state.
					var list : Array = _respondersToUpdateByPath[path];
					
					initializeIfNeccessary(list);
					
					// check for existing validators.
					for each (var responder : IHasStateUpdate in list) {
						responder.updateState(_current.subtract(state), _current, state);
					}
				}
			}
			
			startTransitionIn();
		}

		private function startTransitionIn() : void {
			var toShow : Array = getRespondersToShow();
			
			initializeIfNeccessary(toShow);
			
			var transitioning : Boolean = false;
			for each (var responder : IHasStateTransition in toShow) {
				var status : int = _statusByResponder[responder];
					
				if (status < TransitionStatus.APPEARING || TransitionStatus.SHOWN < status) {
					transitioning = true;
						
					// then continue with the transitionIn() call.
					_statusByResponder[responder] = TransitionStatus.APPEARING;
	
					use namespace transition;
					responder.transitionIn(new TransitionCompleteDelegate(responder, TransitionStatus.SHOWN, this).call);				
				}
			}
				
			if (transitioning) {
				dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
			}
		}

		private function getRespondersToShow() : Array {
			var toShow : Array = getResponderList(_respondersToShowByPath, _current);
			var toHide : Array = getResponderList(_respondersToHideByPath, _current);
			
			// remove elements from the toShow list, if they are in the toHide list.
			for each (var hide : IHasStateTransition in toHide) {
				var hideIndex : int = toShow.indexOf(hide); 
				if (hideIndex >= 0) {
					toShow.splice(hideIndex, 1);
				}
			}
			
			return toShow;
		}

		private function initializeIfNeccessary(inResponderList : Array) : void {
			for each (var responder : INavigationResponder in inResponderList) {
				
				if (_statusByResponder[responder] == TransitionStatus.UNINITIALIZED && responder is IHasStateInitialization) {
					// first initialize the responder.
					IHasStateInitialization(responder).initialize();
					_statusByResponder[responder] = TransitionStatus.INITIALIZED;
				}
			}
		}

		private function getResponderList(inList : Dictionary, inState : NavigationState) : Array {
			var responders : Array = [];
			
			for (var path:String in inList) {
				if (inState.containsState(new NavigationState(path))) {
					responders = responders.concat(inList[path]);
				}
			}
			
			return responders;
		}
	}
}