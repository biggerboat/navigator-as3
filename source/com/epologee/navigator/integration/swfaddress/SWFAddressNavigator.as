package com.epologee.navigator.integration.swfaddress {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * This class extends the Navigator to add SWFAddress capabilities.
	 * 
	 * Example:
	 * var navigator:Navigator = new SWFAddressNavigator();
	 */
	public class SWFAddressNavigator extends Navigator {
		private var _startState : NavigationState;
		private var _hiddenStateContains : Array;
		private var _hiddenStateEquals : Array;

		public function SWFAddressNavigator() {
			super();
		}

		override public function start(defaultStateOrPath : * = "", startStateOrPath : * = null) : void {
			_defaultState = NavigationState.make(defaultStateOrPath);

			if (!startStateOrPath) {
				_startState = _defaultState;
			} else {
				_startState = NavigationState.make(startStateOrPath);
			}

			SWFAddress.addEventListener(SWFAddressEvent.INIT, handleSWFAddressInit);
		}

		public function get startState() : NavigationState {
			return _startState;
		}

		/**
		 * Register a state as hidden to prevent it from showing up in the browser's address bar.
		 * Hidden states also work with wildcard.
		 * @param inExactMatch:	will check on state containment by default (false), or exact match (true).
		 * 
		 * Pseudo code example 'contains':
		 * 
		 * 		registerHiddenState(/a/b/);
		 * 		/a/			-> visible
		 * 		/a/b/		-> hidden
		 * 		/a/b/c		-> hidden
		 * 		/a/b/d		-> hidden
		 * 		
		 * Pseudo code example 'exact match':
		 * 
		 * 		registerHiddenState(/a/b/, true)
		 * 		/a/			-> visible
		 * 		/a/b/		-> hidden
		 * 		/a/b/c/		-> visible
		 * 		/a/b/d/		-> visible
		 * 		
		 * 	Pseudo code example 'wildcard':
		 * 	
		 * 		registerHiddenState(/a/b/*)
		 * 		/a/			-> visible
		 * 		/a/b/		-> visible
		 * 		/a/b/c/		-> hidden
		 * 		/a/b/d/		-> hidden
		 * 		
		 */
		public function registerHiddenState(state : NavigationState, exactMatch : Boolean = false) : void {
			if (exactMatch) {
				_hiddenStateEquals ||= [];
				_hiddenStateEquals.push(state);
			} else {
				_hiddenStateContains ||= [];
				_hiddenStateContains.push(state);
			}
		}

		override protected function notifyStateChange(state : NavigationState) : void {
			if (!isHidden(state)) {
				SWFAddress.setValue(state.path);
			}

			super.notifyStateChange(state);
		}

		private function handleSWFAddressInit(event : SWFAddressEvent) : void {
			var ns : NavigationState = new NavigationState(event.path);

			if (ns.segments.length > 0) {
				// SWFAddress initialized with a starting address
				// We'll overwrite our own starting address for later reference.
				_startState = ns;
			} else {
				if (_startState) {
					requestNewState(_startState);
				} else {
					requestNewState(_defaultState);
				}
			}

			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, handleSWFAddressExternal);
		}

		private function handleSWFAddressExternal(event : SWFAddressEvent) : void {
			/**
			 * A bug in SWFAddress 2.4 will cause the external change to be dispatched
			 * right after the first call to SWFAddress.setValue(). This is of course
			 * an *internal* change, but the navigator will take care of the fact that
			 * we're resubmitting the unchanged state and everything will be fine.
			 * 
			 * It *would* however be nice if the bug in SWFAddress gets fixed.
			 */
			var toRequest : NavigationState = new NavigationState(event.path);

			if (isHidden(toRequest)) {
				if (_current) {
					notifyStateChange(_current);
				} else {
					requestNewState(_defaultState);
				}
			} else {
				try {
					requestNewState(toRequest);
				} catch(error : Error) {
					requestNewState(_defaultState);
				}
			}
		}

		private function isHidden(state : NavigationState) : Boolean {
			for each (var containedState : NavigationState in _hiddenStateContains) {
				if (state.contains(containedState)) {
					logger.info("State is hidden (by containment): " + state);
					return true;
				}
			}

			for each (var equalsState : NavigationState in _hiddenStateEquals) {
				if (state.equals(equalsState)) {
					logger.info("State is hidden (exact match): " + state);
					return true;
				}
			}

			return false;
		}
	}
}
