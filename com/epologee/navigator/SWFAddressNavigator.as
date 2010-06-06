package com.epologee.navigator {
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
		public static const NAME:String = NavigationProxy.NAME;
		
		public function SWFAddressNavigator() {
			super();
		}

		override public function start(inDefaultState : NavigationState, inStartState:NavigationState = null) : void {
			_defaultState = inDefaultState;
			
			SWFAddress.addEventListener(SWFAddressEvent.INIT, handleSWFAddressInit);
		}

		override protected function notifyStateChange(inNewState : NavigationState) : void {
			// may be used in subclassed proxies.
			SWFAddress.setValue(inNewState.path);
			
			super.notifyStateChange(inNewState);
		}

		private function handleSWFAddressInit(event : SWFAddressEvent) : void {
			var ns : NavigationState = new NavigationState(event.path);
			if (_defaultState && ns.segments.length == 0) {
				grantRequest(_defaultState);
			}
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, handleSWFAddressExternal);
		}

		private function handleSWFAddressExternal(event : SWFAddressEvent) : void {
			requestNewState(new NavigationState(event.path));
		}
	}
}
