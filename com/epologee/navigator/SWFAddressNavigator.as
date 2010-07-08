package com.epologee.navigator {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.integration.puremvc.NavigationProxy;
	import com.epologee.navigator.states.NavigationState;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * This class extends the Navigator to add SWFAddress capabilities.
	 * 
	 * Example:
	 * var navigator:Navigator = new SWFAddressNavigator();
	 */
	public class SWFAddressNavigator extends Navigator {
		public static const NAME : String = NavigationProxy.NAME;
		//
		private var _startState : NavigationState;
		private var _hiddenStateContains : Array;
		private var _hiddenStateEquals : Array;

		public function SWFAddressNavigator() {
			super();
		}

		override public function start(inDefaultState : NavigationState, inStartState : NavigationState = null) : void {
			_defaultState = inDefaultState;
			_startState = inStartState;
			
			SWFAddress.addEventListener(SWFAddressEvent.INIT, handleSWFAddressInit);
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
		public function registerHiddenState(inState : NavigationState, inExactMatch:Boolean = false) : void {
			if (inExactMatch) {
				_hiddenStateEquals ||= [];
				_hiddenStateEquals.push(inState);
			} else {
				_hiddenStateContains ||= [];
				_hiddenStateContains.push(inState);
			}
			
			
		}

		override protected function notifyStateChange(inNewState : NavigationState) : void {
			logger.debug("inNewState: " + inNewState);
			
			if (!isHidden(inNewState)) {
				SWFAddress.setValue(inNewState.path);
			}
			
			super.notifyStateChange(inNewState);
		}

		private function handleSWFAddressInit(event : SWFAddressEvent) : void {
			var ns : NavigationState = new NavigationState(event.path);
			if (ns.segments.length == 0) {
				if (_startState) {
					requestNewState(_startState);
				} else {
					grantRequest(_defaultState);
				}
			}
			
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, handleSWFAddressExternal);
		}

		private function handleSWFAddressExternal(event : SWFAddressEvent) : void {
			var toRequest : NavigationState = new NavigationState(event.path);
			
			if (isHidden(toRequest)) {
				if (_current) {
					notifyStateChange(_current);
				} else { 
					requestNewState(_defaultState);
				}
			} else {
				try{
					requestNewState(toRequest);
				}catch(error:Error){
					requestNewState(_defaultState);
				}
			}
		}

		private function isHidden(inState : NavigationState) : Boolean {
			for each (var containedState : NavigationState in _hiddenStateContains) {
				if (inState.containsState(containedState)) {
					logger.info("State is hidden (by containment): " + inState);
					return true;
				}
			}

			for each (var equalsState : NavigationState in _hiddenStateEquals) {
				if (inState.equals(equalsState)) {
					logger.info("State is hidden (exact match): " + inState);
					return true;
				}
			}
			
			return false;
		}	
	}
}
