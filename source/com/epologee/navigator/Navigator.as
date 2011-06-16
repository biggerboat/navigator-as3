package com.epologee.navigator {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateRedirection;
	import com.epologee.navigator.behaviors.IHasStateSwap;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.epologee.navigator.behaviors.IHasStateUpdate;
	import com.epologee.navigator.behaviors.IHasStateValidation;
	import com.epologee.navigator.behaviors.IHasStateValidationAsync;
	import com.epologee.navigator.behaviors.IHasStateValidationOptional;
	import com.epologee.navigator.behaviors.INavigationResponder;
	import com.epologee.navigator.behaviors.NavigationBehaviors;
	import com.epologee.navigator.namespaces.hidden;
	import com.epologee.navigator.namespaces.transition;
	import com.epologee.navigator.namespaces.validation;
	import com.epologee.navigator.transition.TransitionCompleteDelegate;
	import com.epologee.navigator.transition.TransitionStatus;
	import com.epologee.navigator.transition.ValidationPreparedDelegate;

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
	[Event(name="TRANSITION_STATUS_UPDATED", type="com.epologee.navigator.NavigatorEvent")]
	[Event(name="STATE_REQUESTED", type="com.epologee.navigator.NavigatorEvent")]
	[Event(name="STATE_CHANGED", type="com.epologee.navigator.NavigatorEvent")]
	[Event(name="TRANSITION_STARTED", type="com.epologee.navigator.NavigatorEvent")]
	[Event(name="TRANSITION_FINISHED", type="com.epologee.navigator.NavigatorEvent")]
	//
	public class Navigator extends EventDispatcher implements INavigator {
		private static var INSTANCE_COUNT : int = 0;
		//
		protected var _current : NavigationState;
		protected var _previous : NavigationState;
		protected var _defaultState : NavigationState;
		protected var _isTransitioning : Boolean;
		//
		private var _responders : ResponderLists;
		private var _statusByResponder : Dictionary;
		private var _redirects : Dictionary;
		private var _disappearing : AsynchResponders;
		private var _appearing : AsynchResponders;
		private var _swapping : AsynchResponders;
		private var _validating : AsynchResponders;
		private var _inlineRedirection : NavigationState;
		//
		private var _asyncInvalidated : Boolean;
		private var _asyncValidated : Boolean;
		private var _asyncValidationOccurred : Boolean;

		public function Navigator() {
			INSTANCE_COUNT++;
			logger.info("Navigator " + INSTANCE_COUNT + " constructed");

			_responders = new ResponderLists();
			_statusByResponder = new Dictionary();
		}

		/**
		 * @inheritDoc
		 */
		public function add(responder : INavigationResponder, pathsOrStates : *, behavior : String = null) : void {
			modify(true, responder, pathsOrStates, behavior);
		}

		/**
		 * @inheritDoc
		 */
		public function remove(responder : INavigationResponder, pathsOrStates : *, behavior : String = null) : void {
			modify(false, responder, pathsOrStates, behavior);
		}

		/**
		 * @inheritDoc
		 */
		public function registerRedirect(fromStateOrPath : *, toStateOrPath : *) : void {
			_redirects ||= new Dictionary();
			_redirects[NavigationState.make(fromStateOrPath).path] = NavigationState.make(toStateOrPath);
		}

		/**
		 * @inheritDoc
		 */
		public function start(defaultStateOrPath : * = "", startStateOrPath : * = null) : void {
			_defaultState = NavigationState.make(defaultStateOrPath);

			request(startStateOrPath || _defaultState);
		}

		/**
		 * @inheritDoc
		 */
		public function request(stateOrPath : *) : void {
			if (stateOrPath == null) {
				logger.error("Requested a null state. Aborting request.");
				return;
			}

			// Store and possibly mask the requested state
			var requested : NavigationState = NavigationState.make(stateOrPath);
			if (requested.hasWildcard()) {
				requested = requested.mask(_current || _defaultState);
			}

			// Check for exact match of the requested and the current state
			if (_current && _current.path == requested.path) {
				logger.info("Already at the requested state: " + requested);
				return;
			}

			if (_redirects) {
				for (var path : String in _redirects) {
					var from : NavigationState = new NavigationState(path);
					if (from.equals(requested)) {
						var to : NavigationState = NavigationState(_redirects[path]);
						logger.info("Redirecting " + from + " to " + to);
						request(to);
						return;
					}
				}
			}

			// this event makes it possible to add responders just in time to participate in the validation process.
			var ne : NavigatorEvent = new NavigatorEvent(NavigatorEvent.STATE_REQUESTED);
			ne.state = requested;
			dispatchEvent(ne);

			// Inline redirection is reset with every request call.
			// It can be changed by a responder implementing the IHasStateRedirection interface.
			_inlineRedirection = null;

			performRequestCascade(requested);
		}

		/**
		 * @inheritDoc
		 */
		public function get currentState() : NavigationState {
			// not returning the _current instance to prevent possible reference conflicts.
			if (!_current) {
				if (_defaultState)
					return _defaultState.clone();

				return null;
			}

			return _current.clone();
		}

		/**
		 * This method is currently not exposed through the INavigator interface, because you shouldn't rely on it too heavily.
		 * Implement your behaviors correctly and you should be fine.
		 */
		public function get isTransitioning() : Boolean {
			return _isTransitioning;
		}

		private function modify(addition : Boolean, responder : INavigationResponder, pathsOrStates : *, behavior : String = null) : void {
			if (relayModification(addition, responder, pathsOrStates, behavior)) return;

			// Using the path variable as dictionary key to break instance referencing.
			var path : String = NavigationState.make(pathsOrStates).path;
			var list : Array;
			var matchingInterface : Class;

			// Create, store and retrieve the list that matches the desired behavior.
			switch(behavior) {
				case NavigationBehaviors.SHOW:
					matchingInterface = IHasStateTransition;
					list = _responders.showByPath[path] ||= [];
					break;
				case NavigationBehaviors.HIDE:
					matchingInterface = IHasStateTransition;
					list = _responders.hideByPath[path] ||= [];
					break;
				case NavigationBehaviors.VALIDATE:
					matchingInterface = IHasStateValidation;
					list = _responders.validateByPath[path] ||= [];
					break;
				case NavigationBehaviors.UPDATE:
					matchingInterface = IHasStateUpdate;
					list = _responders.updateByPath[path] ||= [];
					break;
				case NavigationBehaviors.SWAP:
					matchingInterface = IHasStateSwap;
					list = _responders.swapByPath[path] ||= [];
					break;
				default:
					throw new Error("Unknown behavior: " + behavior);
			}

			if (!(responder is matchingInterface)) {
				throw new Error("Responder " + responder + " should implement " + matchingInterface + " to respond to " + behavior);
			}

			if (addition) {
				// add
				if (list.indexOf(responder) < 0) {
					list.push(responder);

					// If the responder has no status yet, initialize it to UNINITIALIZED:
					_statusByResponder[responder] ||= TransitionStatus.UNINITIALIZED;
				} else return;
			} else {
				// remove
				var index : int = list.indexOf(responder);
				if (index >= 0) {
					list.splice(index, 1);

					delete _statusByResponder[responder];
				} else return;

				if (matchingInterface == IHasStateSwap && _responders.swappedBefore[responder]) {
					// cleanup after the special swap case
					delete _responders.swappedBefore[responder];
				}
			}

			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		private function relayModification(addition : Boolean, responder : INavigationResponder, pathsOrStates : *, behaviors : String = null) : Boolean {
			if (!responder)
				throw new Error("add: responder is null");

			if (pathsOrStates is Array) {
				for each (var pathOrState : * in pathsOrStates) {
					modify(addition, responder, pathOrState, behaviors);
				}
				return true;
			}

			behaviors ||= NavigationBehaviors.AUTO;
			if (behaviors == NavigationBehaviors.AUTO) {
				for each (var behavior : String in NavigationBehaviors.ALL_AUTO) {
					try {
						modify(addition, responder, pathsOrStates, behavior);
					} catch(e : Error) {
						// ignore 'should implement xyz' errors
					}
				}
				return true;
			}

			return false;
		}

		private function performRequestCascade(requested : NavigationState, startAsyncValidation : Boolean = true) : void {
			if (!_defaultState) throw new Error("No default state set. Call start() before the first request!");
			// Request cascade starts here.
			//
			if (requested.path == _defaultState.path && !_defaultState.hasWildcard()) {
				// Exact match on default state bypasses validation.
				grantRequest(_defaultState);
			} else if (_asyncValidationOccurred && (_asyncValidated && !_asyncInvalidated)) {
				// Async operation completed
				grantRequest(requested);
			} else if (validate(requested, true, startAsyncValidation)) {
				// Any other state needs to be validated.
				grantRequest(requested);
			} else if (_validating && _validating.isBusy()) {
				// Waiting for async validation.
				// FIXME: What do we do in the mean time, dispatch an event or sth?
				logger.notice("waiting for async validation to complete");
			} else if (startAsyncValidation && _asyncValidationOccurred) {
				// any async prepration happened instantaneuously
			} else if (_inlineRedirection) {
				request(_inlineRedirection);
			} else if (_current) {
				// If validation fails, the notifyStateChange() is called with the current state as a parameter,
				// mainly for subclasses to respond to the blocked navigation (e.g. SWFAddress).
				notifyStateChange(_current);
			} else if (requested.hasWildcard()) {
				// If we get here, after validateWithWildcards has failed, this means there are still
				// wildcards in the requested state that didn't match the previous state. This,
				// unfortunately means your application has a logic error. Go fix it!
				throw new Error("Check wildcard masking: " + requested);
			} else if (_defaultState) {
				// If all else fails, we'll put up the default state.
				grantRequest(_defaultState);
			} else {
				// If you don't provide a default state, at least make sure your first request makes sense!
				throw new Error("First request is invalid: " + requested);
			}
		}

		/**
		 * FIXME: The notifyComplete logic is incorrect when two parallel transitions (e.g. both 'in') of the same responder report back with a non-chronological order. 
		 * This will not happen in regular use, but brute-force testing reveals it. The result is elements being visible when they shouldn't and vice versa.
		 */
		transition function notifyComplete(responder : INavigationResponder, status : int, behavior : String) : void {
			if (_statusByResponder[responder]) {
				_statusByResponder[responder] = status;
				dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
			}

			var asynch : AsynchResponders;
			var method : Function;

			switch(behavior) {
				case NavigationBehaviors.HIDE:
					asynch = _disappearing;
					method = flow::performUpdates;
					break;
				case NavigationBehaviors.SHOW:
					asynch = _appearing;
					method = flow::startSwapOut;
					break;
				case NavigationBehaviors.SWAP:
					asynch = _swapping;
					method = flow::swapIn;
					break;
				default:
					throw new Error("Don't know how to handle notification of behavior " + behavior);
			}

			// If the notifyComplete is called instantly, the array of asynchronous responders is not yet assigned, and therefore not busy.
			if (asynch.isBusy()) {
				asynch.takeOutResponder(responder);

				// isBusy counts the number of responders, so it might have changed after takeOutResponder().
				if (!asynch.isBusy()) {
					method();
				} else {
					logger.notice("waiting for " + asynch.length + " responders to " + behavior);
				}
			}
		}

		hidden function hasResponder(responder : INavigationResponder) : Boolean {
			if (_statusByResponder[responder]) return true;

			for each (var respondersByPath : Dictionary in _responders.all) {
				for each (var existingResponders : Array in respondersByPath) {
					if (existingResponders.indexOf(responder) >= 0) return true;
				}
			}

			return false;
		}

		hidden function get statusByResponder() : Dictionary {
			return _statusByResponder;
		}

		hidden function getStatus(responder : IHasStateTransition) : int {
			return _statusByResponder[responder];
		}

		hidden function getKnownPaths() : Array {
			var list : Object = {};
			list[_defaultState.path] = true;

			var path : String;
			for (path in _responders.showByPath) {
				list[new NavigationState(path).path] = true;
			}

			var known : Array = [];
			for (path in list) {
				known.push(path);
			}

			known.sort();
			return known;
		}

		protected function grantRequest(state : NavigationState) : void {
			_asyncInvalidated = false;
			_asyncValidated = false;
			_previous = _current;
			_current = state;

			notifyStateChange(_current);

			flow::startTransition();
		}

		protected function notifyStateChange(state : NavigationState) : void {
			logger.notice(state);

			// Do call the super.notifyStateChange() when overriding.
			if (state != _previous) {
				var ne : NavigatorEvent = new NavigatorEvent(NavigatorEvent.STATE_CHANGED, _statusByResponder);
				ne.state = currentState;
				dispatchEvent(ne);
			}
		}

		validation function notifyValidationPrepared(validator : IHasStateValidationAsync, truncated : NavigationState, full : NavigationState) : void {
			// If the takeOutResponder() method returns false, it was not in the responder list to begin with.
			// This happens if a second navigation state is requested before the async validation preparation of the first completes.
			if (_validating.takeOutResponder(validator)) {
				if (validator.validate(truncated, full)) {
					_asyncValidated = true;
				} else {
					logger.warn("Asynchronously invalidated by " + validator);
					_asyncInvalidated = true;

					if (validator is IHasStateRedirection) {
						_inlineRedirection = IHasStateRedirection(validator).redirect(truncated, full);
					}
				}

				if (!_validating.isBusy()) {
					performRequestCascade(full, false);
				} else {
					logger.notice("Waiting for " + _validating.length + " validators to prepare");
				}
			} else {
				// ignore async preparations of former requests.
			}
		}

		/**
		 * Validation is done in two steps.
		 * 
		 * Firstly, the @param inNavigationState is checked against all registered
		 * state paths in the _responders.showByPath list. If that already results in a
		 * valid path, it will grant the request.
		 * 
		 * Secondly, if not already granted, it will continue to look for existing validators in the _responders.validateByPath.
		 * If found, will call those and have the grant rely on the external validators.
		 */
		private function validate(stateToValidate : NavigationState, allowRedirection : Boolean = true, allowAsyncValidation : Boolean = true) : Boolean {
			var unvalidatedState : NavigationState = stateToValidate;

			// check to see if there are still wildcards left
			if (unvalidatedState.hasWildcard()) {
				// throw new Error("validateState: Requested states may not contain wildcards " + NavigationState.WILDCARD);
				return false;
			}

			if (unvalidatedState.equals(_defaultState)) {
				return true;
			}

			if (allowAsyncValidation) {
				// This conditional is only true if we enter the validation the first (synchronous) time.
				_asyncValidationOccurred = false;
				_asyncInvalidated = false;
				_asyncValidated = false;

				// reset asynchronous validation for every new state.
				_validating = new AsynchResponders();
			}

			var implicit : Boolean = validateImplicitly(unvalidatedState);
			var invalidated : Boolean = false;
			var validated : Boolean = false;

			for (var path : String in _responders.validateByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				if (unvalidatedState.contains(state)) {
					var remainder : NavigationState = unvalidatedState.subtract(state);

					// the lookup path is contained by the new state.
					var list : Array = _responders.validateByPath[path];
					var responder : INavigationResponder;

					initializeIfNeccessary(list);

					if (allowAsyncValidation) {
						// check for async validators first. If this does not
						for each (responder in list) {
							var asyncValidator : IHasStateValidationAsync = responder as IHasStateValidationAsync;

							// check for optional validation
							if (asyncValidator is IHasStateValidationOptional && !IHasStateValidationOptional(asyncValidator).willValidate(remainder, unvalidatedState)) {
								continue;
							}

							if (asyncValidator) {
								_asyncValidationOccurred = true;
								_validating.addResponder(asyncValidator);
								logger.notice("Preparing validation (total of " + _validating.length + ")");

								use namespace validation;
								asyncValidator.prepareValidation(remainder, unvalidatedState, new ValidationPreparedDelegate(asyncValidator, remainder, unvalidatedState, this).call);
							}
						}

						if (_asyncValidationOccurred) {
							//						//  If there are active async validators, stop the validation chain and wait for the prepration to finish.
							// if (_validating.isBusy()) return false;
							// if (_asyncValidationOccurred && (_asyncValidated || _asyncInvalidated) {
							// async validation was instantaneous, which means that the validation was approved or denied elsewhere
							// in the stack. this method should return false any which way.
							return false;
						}
					}

					// check regular validators
					for each (responder in list) {
						var validator : IHasStateValidation = responder as IHasStateValidation;

						// skip async validators, we handled them a few lines back.
						if (validator is IHasStateValidationAsync) continue;

						// check for optional validation
						if (validator is IHasStateValidationOptional && !IHasStateValidationOptional(validator).willValidate(remainder, unvalidatedState)) {
							continue;
						}

						if (validator.validate(remainder, unvalidatedState)) {
							validated = true;
						} else {
							logger.warn("Invalidated by validator: " + validator);
							invalidated = true;

							if (allowRedirection && validator is IHasStateRedirection) {
								_inlineRedirection = IHasStateRedirection(validator).redirect(remainder, unvalidatedState);
							}
						}
					}
				}
			}

			if (_validating.isBusy()) {
				// the request cascade will double check the asynch validators and act accordingly.
				return false;
			}

			// invalidation overrules any validation
			if (invalidated || _asyncInvalidated) {
				return false;
			}

			if (validated || _asyncValidated) {
				return true;
			}

			if (!implicit) {
				logger.warn("Validation failed. No validators or transitions matched the requested " + unvalidatedState);
			}

			return implicit;
		}

		// Check hard wiring of states to transition responders in the show list.
		private function validateImplicitly(state : NavigationState) : Boolean {
			for (var path : String in _responders.showByPath) {
				if (new NavigationState(path).equals(state)) {
					// info("Validation passed based on transition responder.");
					return true;
				}
			}

			return false;
		}

		flow function startTransition() : void {
			_isTransitioning = true;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STARTED));

			_disappearing = new AsynchResponders();
			_disappearing.addResponders(flow::transitionOut());

			if (!_disappearing.isBusy()) {
				flow::performUpdates();
			}
		}

		flow function transitionOut() : Array {
			var toShow : Array = getRespondersToShow();

			// This initialize call is to catch responders that were put on stage to show,
			// yet still need to wait for async out transitions before they actually transition in.
			initializeIfNeccessary(toShow);

			var waitFor : Array = [];

			for (var key:* in _statusByResponder) {
				var responder : IHasStateTransition = key as IHasStateTransition;

				if (toShow.indexOf(responder) < 0) {
					// if the responder is not already hidden or disappearing, trigger the transitionOut:
					if (TransitionStatus.HIDDEN < _statusByResponder[responder] && _statusByResponder[responder] < TransitionStatus.DISAPPEARING) {
						_statusByResponder[responder] = TransitionStatus.DISAPPEARING;
						waitFor.push(responder);

						use namespace transition;
						responder.transitionOut(new TransitionCompleteDelegate(responder, TransitionStatus.HIDDEN, NavigationBehaviors.HIDE, this).call);
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

			if (waitFor.length) {
				dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
			}

			return waitFor;
		}

		flow function performUpdates() : void {
			_disappearing.reset();

			for (var path:String in _responders.updateByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				if (_current.contains(state)) {
					// the lookup path is contained by the new state.
					var list : Array = _responders.updateByPath[path];

					initializeIfNeccessary(list);

					// check for existing validators.
					for each (var responder : IHasStateUpdate in list) {
						responder.updateState(_current.subtract(state), _current);
					}
				}
			}

			flow::startTransitionIn();
		}

		flow function startTransitionIn() : void {
			_appearing = new AsynchResponders();
			_appearing.addResponders(flow::transitionIn());

			if (!_appearing.isBusy()) {
				flow::startSwapOut();
			}
		}

		flow function transitionIn() : Array {
			var toShow : Array = getRespondersToShow();

			initializeIfNeccessary(toShow);

			var waitFor : Array = [];

			for each (var responder : IHasStateTransition in toShow) {
				var status : int = _statusByResponder[responder];

				if (status < TransitionStatus.APPEARING || TransitionStatus.SHOWN < status) {
					// then continue with the transitionIn() call.
					_statusByResponder[responder] = TransitionStatus.APPEARING;
					waitFor.push(responder);

					use namespace transition;
					responder.transitionIn(new TransitionCompleteDelegate(responder, TransitionStatus.SHOWN, NavigationBehaviors.SHOW, this).call);
				}
			}

			// loop backwards so we can splice elements off the array while in the loop.
			for (var i : int = waitFor.length;--i >= 0;) {
				if (_statusByResponder[waitFor[i]] == TransitionStatus.SHOWN) {
					waitFor.splice(i, 1);
				}
			}

			if (waitFor.length) {
				dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
			}

			return waitFor;
		}

		flow function startSwapOut() : void {
			_swapping = new AsynchResponders();
			_swapping.addResponders(flow::swapOut());

			if (!_swapping.isBusy()) {
				flow::swapIn();
			}
		}

		flow function swapOut() : Array {
			_appearing.reset();

			var waitFor : Array = [];

			for (var path:String in _responders.swapByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				if (_current.contains(state)) {
					// the lookup path is contained by the new state.
					var list : Array = _responders.swapByPath[path];

					initializeIfNeccessary(list);

					// check for existing swaps.
					for each (var responder : IHasStateSwap in list) {
						if (!_responders.swappedBefore[responder])
							continue;

						var truncated : NavigationState = _current.subtract(state);
						if (responder.willSwapToState(truncated, _current)) {
							_statusByResponder[responder] = TransitionStatus.SWAPPING;
							waitFor.push(responder);

							use namespace transition;
							responder.swapOut(new TransitionCompleteDelegate(responder, TransitionStatus.SHOWN, NavigationBehaviors.SWAP, this).call);
						}
					}
				}
			}

			// loop backwards so we can splice elements off the array while in the loop.
			for (var i : int = waitFor.length;--i >= 0;) {
				if (_statusByResponder[waitFor[i]] == TransitionStatus.SHOWN) {
					waitFor.splice(i, 1);
				}
			}

			if (waitFor.length) {
				dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
			}

			return waitFor;
		}

		flow function swapIn() : void {
			_swapping.reset();

			for (var path:String in _responders.swapByPath) {
				// create a state object for comparison:
				var state : NavigationState = new NavigationState(path);

				if (_current.contains(state)) {
					// the lookup path is contained by the new state.
					var list : Array = _responders.swapByPath[path];

					initializeIfNeccessary(list);

					// check for existing swaps.
					for each (var responder : IHasStateSwap in list) {
						var truncated : NavigationState = _current.subtract(state);
						if (responder.willSwapToState(truncated, _current)) {
							_responders.swappedBefore[responder] = true;
							responder.swapIn(truncated, _current);
						}
					}
				}
			}

			flow::finishTransition();
		}

		flow function finishTransition() : void {
			_isTransitioning = false;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_FINISHED));
		}

		private function getRespondersToShow() : Array {
			var toShow : Array = getResponderList(_responders.showByPath, _current);
			var toHide : Array = getResponderList(_responders.hideByPath, _current);

			// remove elements from the toShow list, if they are in the toHide list.
			for each (var hide : IHasStateTransition in toHide) {
				var hideIndex : int = toShow.indexOf(hide);
				if (hideIndex >= 0) {
					toShow.splice(hideIndex, 1);
				}
			}

			return toShow;
		}

		private function initializeIfNeccessary(responderList : Array) : void {
			for each (var responder : INavigationResponder in responderList) {
				if (_statusByResponder[responder] == TransitionStatus.UNINITIALIZED && responder is IHasStateInitialization) {
					// first initialize the responder.
					IHasStateInitialization(responder).initialize();
					_statusByResponder[responder] = TransitionStatus.INITIALIZED;
				}
			}
		}

		private function getResponderList(list : Dictionary, state : NavigationState) : Array {
			var responders : Array = [];

			for (var path:String in list) {
				if (state.contains(new NavigationState(path))) {
					responders = responders.concat(list[path]);
				}
			}

			return responders;
		}
	}
}
import com.epologee.development.logging.logger;
import com.epologee.navigator.behaviors.INavigationResponder;

import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;
/**	
 * The flow namespace is used privately, to mark methods that belong to the transition flow group.
 */
namespace flow;
class ResponderLists {
	public var validateByPath : Dictionary = new Dictionary();
	public var updateByPath : Dictionary = new Dictionary();
	public var swapByPath : Dictionary = new Dictionary();
	public var showByPath : Dictionary = new Dictionary();
	public var hideByPath : Dictionary = new Dictionary();
	public var swappedBefore : Dictionary = new Dictionary();
	public var all : Array = [validateByPath, updateByPath, swapByPath, showByPath, hideByPath, swappedBefore];

	public function toString() : String {
		var described : XML = describeType(this);
		var variables : XMLList = described.child("variable");
		var s : String = "ResponderLists [";
		for each (var variable : XML in variables) {
			if (variable.@type == getQualifiedClassName(Dictionary)) {
				var list : Dictionary = this[variable.@name];
				var contents : Array = [];
				for (var key:* in list) {
					contents.push("[" + key + " = " + list[key] + "]");
				}
				s += "\n\t[" + variable.@name + ": " + contents.join(", ") + "], ";
			}
		}

		s += "]";
		return s;
	}
}
class AsynchResponders {
	private var responders : Array = [];

	public function get length() : int {
		return responders.length;
	}

	public function isBusy() : Boolean {
		return length > 0;
	}

	public function hasResponder(responder : INavigationResponder) : Boolean {
		return responders.indexOf(responder) >= 0;
	}

	public function addResponder(responder : INavigationResponder) : void {
		responders.push(responder);
	}

	public function addResponders(additionalResponders : Array) : void {
		if (additionalResponders && additionalResponders.length) {
			responders = responders.concat(additionalResponders);
		}
	}

	public function takeOutResponder(responder : INavigationResponder) : Boolean {
		var index : int = responders.indexOf(responder);
		if (index >= 0) {
			responders.splice(index, 1);
			return true;
		}

		return false;
	}

	public function reset() : void {
		if (responders.length)
			logger.warn("Resetting too early? Still have responders marked for asynchronous tasks");
			
		responders = [];
	}
}
