package com.epologee.navigator {
	import com.epologee.navigator.responders.IHasStateInitialization;
	import com.epologee.navigator.responders.IHasStateTransition;
	import com.epologee.navigator.responders.IHasStateUpdate;
	import com.epologee.navigator.responders.IHasStateValidation;
	import com.epologee.navigator.responders.INavigationResponder;

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
		private var _statusByResponder : Dictionary;
		private var _disappearingResponders : Array;
		private var _disappearingAsynchronously : Boolean;

		public function Navigator() {
			_respondersToValidateByPath = new Dictionary();
			_respondersToUpdateByPath = new Dictionary();
			_respondersToShowByPath = new Dictionary();
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

		public function addShowResponder(inResponder : IHasStateTransition, inPath : String) : void {
			if (!inResponder) return;
			var path : String = new NavigationState(inPath).path;
			
			// retrieve or create the list of responders to show for the current path:
			var showList : Array = _respondersToShowByPath[path] = _respondersToShowByPath[path] ? _respondersToShowByPath[path] : [];
			showList.push(inResponder);
			
			// If there is no status yet, set the initial status to UNINITIALIZED:			
			_statusByResponder[inResponder] = _statusByResponder[inResponder] ? _statusByResponder[inResponder] : TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		public function removeShowResponder(inResponder : IHasStateTransition, inPath : String) : void {
			var path : String = new NavigationState(inPath).path;
						
			// retrieve the list of responders to show for the current path:
			var showList : Array = _respondersToShowByPath[path];
			if (!showList) {
				warn("path not found " + path);
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

		public function addUpdateResponder(inResponder : IHasStateUpdate, inPath : String) : void {
			if (!inResponder) return;
			var path : String = new NavigationState(inPath).path;
						
			// retrieve or create the list of responders to update for the current path:
			var updateList : Array = _respondersToUpdateByPath[path] = _respondersToUpdateByPath[path] ? _respondersToUpdateByPath[path] : [];
			updateList.push(inResponder);

			// If there is no status yet, set the initial status to UNINITIALIZED:			
			_statusByResponder[inResponder] = _statusByResponder[inResponder] ? _statusByResponder[inResponder] : TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		public function addValidateResponder(inResponder : IHasStateValidation, inPath : String) : void {
			if (!inResponder) {
				warn("no responder! " + inResponder);
				return;
			}
			var path : String = new NavigationState(inPath).path;
						
			// retrieve or create the list of responders to update for the current path:
			var validateList : Array = _respondersToValidateByPath[path] = _respondersToValidateByPath[path] ? _respondersToValidateByPath[path] : [];
			validateList.push(inResponder);

			// If there is no status yet, set the initial status to UNINITIALIZED:			
			_statusByResponder[inResponder] = _statusByResponder[inResponder] ? _statusByResponder[inResponder] : TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
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
			if (_current && _current.path == inNavigationState.path) {
				return;
			}
			
			if (inNavigationState == _defaultState) {
				// Default state bypasses validation.
				grantRequest(_defaultState);
			} else if (validateState(inNavigationState)) {
				// Any other state needs to be validated.
				grantRequest(inNavigationState);
			} else if (_current) {
				// If validation fails, the notifyStateChange() is called with the current state as a parameter,
				// mainly for subclasses to respond to the blocked navigation (e.g. SWFAddress). 
				warn("Reverting to previous state " + _current);
				notifyStateChange(_current);
				return;
			} else {
				// The _current state can only be null if there hasn't been a call to grantRequest() yet.
				// In the regular setup, this cannot happen, but if you subclass this Proxy,
				// it might (e.g. SWFAddress starting at another address). In that case we request
				// the default state, which always passes validation.
				warn("Reverting to default state " + _defaultState);
				requestNewState(_defaultState);
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

		internal function notifyComplete(inResponder : IHasStateTransition, inStatus : int) : void {
			_statusByResponder[inResponder] = inStatus;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));

			if (_disappearingAsynchronously && inStatus == TransitionStatus.HIDDEN) {
				var index : int = _disappearingResponders.indexOf(inResponder);
				if (index >= 0) {
					_disappearingResponders.splice(index, 1);
				
					if (!_disappearingResponders.length) {
						performUpdates();
					} else {
						notice("waiting for " + _disappearingResponders.length + " responders to disappear");
					}
				}
			}
		}

		protected function notifyStateChange(inNewState : NavigationState) : void {
			// may be used in subclassed proxies.
		}

		protected function grantRequest(inNavigationState : NavigationState) : void {
			_current = inNavigationState;
			info("Granted state " + _current);
			
			notifyStateChange(_current);

			_disappearingAsynchronously = false;
			_disappearingResponders = startTransitionOut(); 
			
			if (_disappearingResponders.length) {
				_disappearingAsynchronously = true;
			} else {
				performUpdates();	
			}
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
					foundValidators = true;
                    
					// the lookup path is contained by the new state.
					var list : Array = _respondersToValidateByPath[path];
                                
					initializeIfNeccessary(list);
                    
                    // check for existing validators.
					for each (var responder : INavigationResponder in list) {
						var validator : IHasStateValidation = responder as IHasStateValidation;
						if (validator.validate(inNavigationState, state) == ValidationResult.FAIL) {
							warn("Validation failed based on validation responder: " + validator);
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
				warn("Validation failed. No validators or transitions matched the requested " + inNavigationState);
			}
            
			return direct;
		}

		private function startTransitionOut() : Array {
			var toShow : Array = getResponderList(_respondersToShowByPath, _current);
			var waitFor : Array = [];
			
			for (var key:* in _statusByResponder) {
				var responder : IHasStateTransition = key as IHasStateTransition;
				 
				if (toShow.indexOf(responder) < 0) {

					// if the responder is not already hidden or disappearing, trigger the transitionOut:
					if (TransitionStatus.HIDDEN < _statusByResponder[responder] && _statusByResponder[responder] < TransitionStatus.DISAPPEARING) {
						_statusByResponder[responder] = TransitionStatus.DISAPPEARING;
						waitFor.push(responder);
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
						responder.updateState(_current, state);
					}
				}
			}
			
			startTransitionIn();
		}

		private function startTransitionIn() : void {
			var toShow : Array = getResponderList(_respondersToShowByPath, _current);
			
			initializeIfNeccessary(toShow);
			
			for each (var responder : IHasStateTransition in toShow) {
				var status : int = _statusByResponder[responder];
				
				if (status < TransitionStatus.APPEARING || TransitionStatus.SHOWN < status) {
					// then continue with the transitionIn() call.
					_statusByResponder[responder] = TransitionStatus.APPEARING;
					responder.transitionIn(new TransitionCompleteDelegate(responder, TransitionStatus.SHOWN, this).call);				
				}
			}
		}

		private function initializeIfNeccessary(inResponderList : Array) : void {
			for each (var responder : INavigationResponder in inResponderList) {
				
				if (_statusByResponder[responder] == TransitionStatus.UNINITIALIZED) {
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