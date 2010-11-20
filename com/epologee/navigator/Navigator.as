package com.epologee.navigator {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.behaviors.IHasStateInitialization;
	import com.epologee.navigator.behaviors.IHasStateSwap;
	import com.epologee.navigator.behaviors.IHasStateTransition;
	import com.epologee.navigator.behaviors.IHasStateUpdate;
	import com.epologee.navigator.behaviors.IHasStateValidation;
	import com.epologee.navigator.behaviors.IHasStateValidationOptional;
	import com.epologee.navigator.behaviors.INavigationResponder;
	import com.epologee.navigator.behaviors.NavigationBehaviors;
	import com.epologee.navigator.namespaces.hidden;
	import com.epologee.navigator.namespaces.transition;
	import com.epologee.navigator.transition.TransitionCompleteDelegate;
	import com.epologee.navigator.transition.TransitionStatus;

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
	[Event(name="STATE_CHANGED", type="com.epologee.navigator.NavigatorEvent")]
	//
	public class Navigator extends EventDispatcher {
		public static var MAX_HISTORY_LENGTH : Number = 50;
		//
		protected var _current : NavigationState;
		protected var _previous : NavigationState;
		protected var _defaultState : NavigationState;
		//
		private var _responders : ResponderLists;
		private var _statusByResponder : Dictionary;
		private var _redirects : Dictionary;
		private var _disappearing : AsynchResponders;
		private var _appearing : AsynchResponders;
		private var _swapping : AsynchResponders;

		public function Navigator() {
			_responders = new ResponderLists();
			_statusByResponder = new Dictionary();
		}

		public function add(inResponder : INavigationResponder, inPathOrState : *, inBehavior : String = NavigationBehaviors.SHOW) : void {
			if (!inResponder)
				throw new Error("add: responder is null");

			if (inBehavior == NavigationBehaviors.AUTO) {
				autoAdd(inResponder, inPathOrState);
				return;
			}

			// Using the path variable as dictionary key to break instance referencing.
			var path : String = new NavigationState(inPathOrState).path;
			var list : Array;
			var matchingInterface : Class;

			// Create, store and retrieve the list that matches the desired behavior.
			switch(inBehavior) {
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
					throw new Error("Unknown behavior: " + inBehavior);
			}

			if (!(inResponder is matchingInterface)) {
				throw new Error("Responder " + inResponder + " should implement " + matchingInterface + " to respond to " + inBehavior);
			}

			list.push(inResponder);

			// If the responder has no status yet, initialize it to UNINITIALIZED:
			_statusByResponder[inResponder] ||= TransitionStatus.UNINITIALIZED;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));
		}

		public function registerRedirect(inFrom : NavigationState, inTo : NavigationState) : void {
			_redirects ||= new Dictionary();
			_redirects[inFrom.path] = inTo;
		}

		public function start(inDefaultState : NavigationState, inStartState : NavigationState = null) : void {
			_defaultState = inDefaultState;

			if (inStartState) {
				requestNewState(inStartState);
			} else {
				grantRequest(_defaultState);
			}
		}

		/** TODO: Add removeXYZ methods for removing responders */
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
			// Check for exact match of the requested and the current state
			if (_current && _current.path == inNavigationState.path) {
				logger.info("Already at the requested state: " + inNavigationState);
				return;
			}

			if (_redirects) {
				for (var path : String in _redirects) {
					var from : NavigationState = new NavigationState(path);
					if (from.equals(inNavigationState)) {
						var to : NavigationState = NavigationState(_redirects[path]);
						notifyStateChange(from);
						logger.info("Redirecting " + from + " to " + to);
						requestNewState(to);
						return;
					}
				}
			}

			logger.debug(inNavigationState);

			if (inNavigationState.path == _defaultState.path) {
				// Exact match on default state bypasses validation.
				// notice("matches default state: " + inNavigationState);
				grantRequest(_defaultState);
			} else if (validate(inNavigationState)) {
				// Any other state needs to be validated.
				// notice("validated: " + inNavigationState + " with current: " + _current);
				grantRequest(inNavigationState);
			} else if (validateWithWildcards(inNavigationState)) {
				// Validation passed after wildcard masking.
				// notice("validated: " + inNavigationState + " masked by current: " + _current);
				grantRequest(inNavigationState.mask(_current));
			} else if (_current) {
				// If validation fails, the notifyStateChange() is called with the current state as a parameter,
				// mainly for subclasses to respond to the blocked navigation (e.g. SWFAddress).
				// notice("reverting to current from: " + inNavigationState);
				notifyStateChange(_current);
				return;
			} else if (inNavigationState.hasWildcard()) {
				throw new Error("Check wildcard masking: " + inNavigationState);
			} else if (_defaultState) {
				grantRequest(_defaultState);
			} else {
				throw new Error("First request is invalid: " + inNavigationState);
			}
		}

		public function getCurrentState() : NavigationState {
			// not returning the _current instance to prevent possible reference conflicts.
			if (!_current)
				return null;

			return _current.clone();
		}

		transition function notifyComplete(inResponder : INavigationResponder, inStatus : int, inBehavior : String) : void {
			_statusByResponder[inResponder] = inStatus;
			dispatchEvent(new NavigatorEvent(NavigatorEvent.TRANSITION_STATUS_UPDATED, _statusByResponder));

			var asynch : AsynchResponders;
			var method : Function;

			switch(inBehavior) {
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
					throw new Error("Don't know how to handle notification of behavior " + inBehavior);
			}

			// If the notifyComplete is called instantly, the array of asynchronous responders is not yet assigned, and therefore not busy.
			if (asynch.isBusy()) {
				asynch.takeOutResponder(inResponder);

				if (!asynch.isBusy()) {
					method();
				} else {
					logger.notice("waiting for " + asynch.responders.length + " responders to " + inBehavior);
				}
			}
		}

		hidden function get statusByResponder() : Dictionary {
			return _statusByResponder;
		}

		hidden function getStatus(inResponder : IHasStateTransition) : int {
			return _statusByResponder[inResponder];
		}

		hidden function getKnownPaths() : Array {
			var list : Object = {};

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

		protected function grantRequest(inNavigationState : NavigationState) : void {
			_previous = _current;
			_current = inNavigationState;

			notifyStateChange(_current);

			flow::startTransition();
		}

		protected function notifyStateChange(inNewState : NavigationState) : void {
			// Do call the super.notifyStateChange() when overriding.
			if (inNewState != _previous) {
				var ne : NavigatorEvent = new NavigatorEvent(NavigatorEvent.STATE_CHANGED, _statusByResponder);
				ne.state = getCurrentState();
				dispatchEvent(ne);
			}
		}

		private function autoAdd(inResponder : INavigationResponder, inPathOrState : *) : void {
			for each (var behavior : String in NavigationBehaviors.ALL_AUTO) {
				try {
					add(inResponder, inPathOrState, behavior);
				} catch(e : Error) {
					// ignore error
				}
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
		private function validate(inState : NavigationState) : Boolean {
			var state : NavigationState;
			var path : String;

			// check to see if there are still wildcards left
			if (inState.hasWildcard()) {
				// throw new Error("validateState: Requested states may not contain wildcards " + NavigationState.WILDCARD);
				return false;
			}

			if (inState.equals(_defaultState)) {
				return true;
			}

			var direct : Boolean = false;
			var invalidated : Boolean = false;
			var validated : Boolean = false;

			// This first loop will check hard wiring of states to transition responders in the show list.
			for (path in _responders.showByPath) {
				state = new NavigationState(path);

				if (state.equals(inState)) {
					// info("Validation passed based on transition responder.");
					direct = true;
				}
			}

			// The second loop will check for custom validators.
			for (path in _responders.validateByPath) {
				// create a state object for comparison:
				state = new NavigationState(path);

				if (inState.contains(state)) {
					var remainder : NavigationState = inState.subtract(state);

					// the lookup path is contained by the new state.
					var list : Array = _responders.validateByPath[path];

					initializeIfNeccessary(list);

					// check for existing validators.
					for each (var responder : INavigationResponder in list) {
						var validator : IHasStateValidation = responder as IHasStateValidation;

						// check for optional validation
						if (validator is IHasStateValidationOptional && !IHasStateValidationOptional(validator).willValidate(remainder, inState)) {
							continue;
						}

						if (validator.validate(remainder, inState)) {
							validated = true;
						} else {
							logger.warn("Invalidated by validator: " + validator);
							invalidated = true;
						}
					}
				}
			}

			// invalidation overrules any validation
			if (invalidated) {
				return false;
			}

			if (validated) {
				return true;
			}

			if (!direct && !invalidated && !validated) {
				logger.warn("Validation failed. No validators or transitions matched the requested " + inState);
			}

			return direct;
		}

		private function validateWithWildcards(inState : NavigationState) : Boolean {
			if (inState.hasWildcard()) {
				// run by regular validation.
				return validate(inState.mask(_current));
			}

			return false;
		}

		flow function startTransition() : void {
			_disappearing = new AsynchResponders();
			_disappearing.responders = flow::transitionOut();

			if (!_disappearing.isBusy()) {
				flow::performUpdates();
			}
		}

		flow function transitionOut() : Array {
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
			_appearing.responders = flow::transitionIn();

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
			_swapping.responders = flow::swapOut();

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
			// logger.notice();
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
				if (inState.contains(new NavigationState(path))) {
					responders = responders.concat(inList[path]);
				}
			}

			return responders;
		}
	}
}
import com.epologee.development.logging.logger;
import com.epologee.navigator.behaviors.INavigationResponder;

import flash.utils.Dictionary;
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
}
class AsynchResponders {
	public var responders : Array = [];

	public function isBusy() : Boolean {
		return responders && responders.length;
	}

	public function hasResponder(inResponder : INavigationResponder) : Boolean {
		return responders.indexOf(inResponder) >= 0;
	}

	public function takeOutResponder(inResponder : INavigationResponder) : Boolean {
		var index : int = responders.indexOf(inResponder);
		if (index >= 0) {
			responders.splice(index, 1);
			return true;
		}

		return false;
	}

	public function reset() : void {
		if (responders && responders.length)
			logger.warn("Resetting too early? Still have responders marked for asynchronous tasks");
		responders = null;
	}
}