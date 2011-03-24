package com.epologee.navigator.features.history {
	import com.epologee.navigator.NavigationState;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.NavigatorEvent;

	/**
	 * Provides history management for the Navigator package. 
	 *
	 * @example 
	 * 	<code>
	 * 		
	 * 		// Create the normal navigator
	 * 		var myNavigator : Navigator = new Navigator();
	 * 		
	 * 		// Create the history and supply the navigator it should manage
	 * 		var myHistory : NavigatorHistory = new NavigatorHistory(myNavigator);
	 * 		
	 * 		-----
	 * 		
	 * 		// Go back in time
	 * 		myHistory.back();
	 * 		
	 * 	</code>
	 * @author Studio Sugarfree - Laurent
	 * @created 20 okt 2010
	 */
	public class NavigatorHistory {
		// Default max history length
		public static const MAX_HISTORY_LENGTH : int = 100;
		// Navigation direction types
		public static const DIRECTION_BACK : int = -1;
		public static const DIRECTION_NORMAL : int = 0;
		public static const DIRECTION_FORWARD : int = 1;
		//
		// The navigator it is controlling
		private var _navigator : Navigator;
		// The history, last state is at start of Array
		private var _history : Array;
		// The current position in history
		private var _historyPosition : int = 0;
		// The navigator doesn't know anything about going forward or back.
		// Therefore, we need to keep track of the direction.
		// This is changed when the forward or back methods are called.
		private var _navigationDirection : int = DIRECTION_NORMAL;
		// The max number of history states
		private var _maxLength : int = MAX_HISTORY_LENGTH;

		/**
		 * Create the history manager. When navigating back and forword, the history is maintained. 
		 * It is truncated when navigating to a state naturally
		 * 
		 * @param navigator Navigator reference
		 */
		public function NavigatorHistory(navigator : Navigator) {
			_navigator = navigator;
			_navigator.addEventListener(NavigatorEvent.STATE_CHANGED, handleStateChange);
			_history = new Array();
		}

		/**
		 * Set the maximum number of states
		 */
		public function set maxLength(value : int) : void {
			_maxLength = value;
		}

		/**
		 * Get the maximum number of states
		 */
		public function get maxLength() : int {
			return _maxLength;
		}

		/**
		 * Get an array with the states in the history
		 */
		public function get history() : Array {
			return _history;
		}

		/**
		 * Go back in the history
		 * 
		 * @param steps The number of steps to go back in history
		 * @return Returns false if there was no previous state
		 */
		public function back(steps : int = 1) : Boolean {
			if (_historyPosition == _history.length - 1) {
				return false;
			}
			_historyPosition = Math.min(_history.length - 1, _historyPosition + steps);
			_navigationDirection = NavigatorHistory.DIRECTION_BACK;
			navigateToCurrentHistoryPosition();
			return true;
		}

		/**
		 * Go forward in the history
		 * 
		 * @param steps The number of steps to go forward in history
		 * @return Returns false if there was no next state
		 */
		public function forward(steps : int = 1) : Boolean {
			if (_historyPosition == 0) {
				return false;
			}
			_historyPosition = Math.max(0, _historyPosition - steps);
			_navigationDirection = NavigatorHistory.DIRECTION_FORWARD;
			navigateToCurrentHistoryPosition();
			return true;
		}

		/**
		 * Get the state by historyposition
		 * 
		 * @param position The position in history
		 * @return The found state or null if no state was found
		 */
		public function getStateByPosition(position : int) : NavigationState {
			if (position < 0 || position > _history.length - 1) {
				return null;
			}
			return _history[position] as NavigationState;
		}

		/**
		 * Get the first occurence of a state in the history
		 * 
		 * @param state The state in history
		 * @return The found position or -1 if no position was found
		 */
		public function getPositionByState(state : NavigationState) : int {
			return _history.indexOf(state);
		}

		/**
		 * Tell the navigator to go the current historyPosition
		 */
		private function navigateToCurrentHistoryPosition() : void {
			var newState : NavigationState = _history[_historyPosition];
			_navigator.requestNewState(newState);
		}

		/**
		 * Check what to do with the new state
		 */
		private function handleStateChange(event : NavigatorEvent) : void {
			var state : NavigationState = event.state;
			
			switch (_navigationDirection) {
				case NavigatorHistory.DIRECTION_BACK:
					_navigationDirection = NavigatorHistory.DIRECTION_NORMAL;
					break;
				case NavigatorHistory.DIRECTION_NORMAL:
					// Strip every history state before current
					_history.splice(0, _historyPosition);
					// Add the state at the beginning of the history array
					_history.unshift(state);
					_historyPosition = 0;
					// Truncate the history to the max allowed items
					_history.length = Math.min(_history.length, _maxLength);
					break;
				case NavigatorHistory.DIRECTION_FORWARD:
					_navigationDirection = NavigatorHistory.DIRECTION_NORMAL;
					break;
			}
		}
	}
}