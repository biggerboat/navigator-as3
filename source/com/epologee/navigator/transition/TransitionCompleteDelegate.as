package com.epologee.navigator.transition {
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.behaviors.INavigationResponder;
	import com.epologee.navigator.namespaces.transition;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TransitionCompleteDelegate {
		private var _navigator : Navigator;
		private var _behavior : String;
		private var _status : int;
		private var _responder : INavigationResponder;
		private var _called : Boolean;

		public function TransitionCompleteDelegate(responder : INavigationResponder, status : int, behavior:String, navigator : Navigator) {
			_responder = responder;
			_status = status;
			_behavior = behavior;
			_navigator = navigator;
		}

		/**
		 * The reason this method has rest parameter, is because
		 * then you can either call it by using call() or bind it
		 * to an event handler that will send an event argument.
		 * 
		 * The arguments are ignored.
		 */
		transition function call(...ignoreParameters) : void {
			if (_called) throw new Error("Illegal second call to transition complete. This instance is already prepared for garbage collection!");
			
			_called = true;
			_navigator.transition::notifyComplete(_responder, _status, _behavior);
			_responder = null;
			_navigator = null;
		}
	}
}
