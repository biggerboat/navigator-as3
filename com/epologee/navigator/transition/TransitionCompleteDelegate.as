package com.epologee.navigator.transition {
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.states.IHasStateTransition;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TransitionCompleteDelegate {
		private var _responder : IHasStateTransition;
		private var _navigator : Navigator;
		private var _status : int;

		public function TransitionCompleteDelegate(inResponder : IHasStateTransition, inStatus : int, inNavigator : Navigator) {
			_responder = inResponder;
			_status = inStatus;
			_navigator = inNavigator;
		}

		/**
		 * The reason this method has rest parameter, is because
		 * then you can either call it by using call() or bind it
		 * to an event handler that will send an event argument.
		 * 
		 * The arguments are ignored.
		 */
		transition function call(...inAnyArgument : Array) : void {
			_navigator.transition::notifyComplete(_responder, _status);
			_responder = null;
			_navigator = null;
		}
	}
}
