package com.epologee.navigator {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.epologee.development.logging.debug;
	import com.epologee.development.logging.warn;
	import com.epologee.navigator.integration.puremvc.NavigationProxy;
	import com.epologee.navigator.states.NavigationState;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 * 
	 * This class extends the Navigator to add SWFAddress capabilities.
	 * 
	 * You only need to use this instead when you construct the Navigator, for this class adds nothing
	 * to the API, just alters a few internal changes.
	 * 
	 * Example:
	 * var navigator:Navigator = new SWFAddressNavigator();
	 */
	public class SWFAddressNavigator extends Navigator {
		public static const NAME : String = NavigationProxy.NAME;
		//
		private var _startState : NavigationState;
		private var _hiddenStates : Array;

		public function SWFAddressNavigator() {
			super();
		}

		override public function start(inDefaultState : NavigationState, inStartState : NavigationState = null) : void {
			_defaultState = inDefaultState;
			_startState = inStartState;
			
			SWFAddress.addEventListener(SWFAddressEvent.INIT, handleSWFAddressInit);
		}

		public function registerHiddenState(inState : NavigationState) : void {
			_hiddenStates ||= [];
			_hiddenStates.push(inState);
		}

		override protected function notifyStateChange(inNewState : NavigationState) : void {
			debug("inNewState: " + inNewState);
			
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
			
			if (!isHidden(toRequest)) {
				requestNewState(toRequest);
			}
		}

		private function isHidden(inState : NavigationState) : Boolean {
			for each (var hidden : NavigationState in _hiddenStates) {
				if (hidden.equals(inState)) {
					warn("State is hidden: " + inState);
					return true;
				}
			}
			
			return false;
		}	
	}
}
