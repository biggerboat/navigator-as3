package com.epologee.navigator.integration.puremvc {
	import com.epologee.development.logging.logger;
	import com.epologee.navigator.Navigator;
	import com.epologee.navigator.NavigatorEvent;
	import com.epologee.navigator.SWFAddressNavigator;
	import com.epologee.navigator.states.IHasStateTransition;
	import com.epologee.navigator.states.IHasStateUpdate;
	import com.epologee.navigator.states.IHasStateValidation;
	import com.epologee.navigator.states.INavigationResponder;
	import com.epologee.navigator.states.NavigationState;

	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigationProxy extends Proxy {
		public static const NAME : String = getQualifiedClassName(NavigationProxy);
		//
		public static const TRANSITION_STATUS_UPDATED : String = NAME + ":TRANSITION_STATUS_UPDATED";
		public static const RESPONDER_ADDED : String = NAME + ":RESPONDER_ADDED";
		public static const RESPONDER_REMOVED : String = NAME + ":RESPONDER_REMOVED";
		public static const NAVIGATION_STARTED : String = NAME + ":NAVIGATION_STARTED";
		public static const STATE_CHANGED : String = NAME + ":STATE_CHANGED";
		//
		private var _navigator : Navigator;

		public function NavigationProxy(inUseSWFAddress : Boolean) {
			super(NAME);
			
			_navigator = inUseSWFAddress ? new SWFAddressNavigator() : new Navigator();
			_navigator.addEventListener(NavigatorEvent.TRANSITION_STATUS_UPDATED, handleTransitionStatusUpdate);
			_navigator.addEventListener(NavigatorEvent.STATE_CHANGED, handleStateChanged);
		}

		public function start(inDefaultState : NavigationState, inStartState : NavigationState = null) : void {
			_navigator.start(inDefaultState, inStartState);
			sendNotification(NAVIGATION_STARTED);
		}

		/**
		 * Will use the mediator names in the <show />, <update /> and <validate /> nodes
		 * and register the actual mediator instances in the corresponding navigation lists.
		 * 
		 * If you want to add non-mediator instances to show, update or validate, you can use
		 * the public add...Responder methods.
		 * 
		 * @param inMap an XML map following this example:
		 * 
		 * @example:
		 * 
		 *	var np : NavigationProxy = NavigationProxy(facade.retrieveProxy(NavigationProxy.NAME));
		 *	
		 *	var map : XML = <map>
		 *		<state path="/">
		 *			<show>{LogoMediator.NAME}</show>
		 *			<show>{PortfolioMediator.NAME}</show>
		 *			<show>{MenuMediator.NAME}</show>
		 *			<show>{FullScreenMediator.NAME}</show>
		 *			<update>{MenuMediator.NAME}</update>
		 *		</state>
		 *		<state path="/portfolio/">
		 *			<validate>{PortfolioMediator.NAME}</validate>
		 *			<update>{PortfolioMediator.NAME}</update>
		 *		</state>
		 *	</map>;
		 *	
		 *	np.parseMediatorStateMap(map);
		 *
		 */
		public function parseMediatorStateMap(inMap : XML) : void {
			var states : XMLList = inMap.child("state");
			
			var addMethods : Object = {
				show: addResponderShow, update: addResponderUpdate, validate: addResponderValidate, hide: addResponderHide, auto: addResponderByInterface
			};
			
			var leni : int = states.length();
			for (var i : int = 0;i < leni;i++) {
				var state : XML = states[i];
				var path : String = state.@path;
				
				var responders : XMLList = XMLList(states[i]).children();
				var lenj : int = responders.length();
				for (var j : int = 0;j < lenj;j++) {
					// responders must be mediator implementing inavigationresponder
					var node : XML = responders[j] as XML;
					var untypedResponder : * = facade.retrieveMediator(node);
					if (!untypedResponder) {
						logger.error("Not found in Facade: " + node);
						continue;
					}
					
					var responder : INavigationResponder = facade.retrieveMediator(node) as INavigationResponder;
					try {
						addMethods[node.name().localName](responder, path);
					} catch (e : Error) {
						if (e.errorID == 1034 && e.message.length > 11) {
							var type : String = e.message.split(" ").pop();
							type = type.substr(0, type.length - 1);
							logger.warn(untypedResponder + " should implement [" + type + "], if you want to use it as <" + node.name().localName + " />");
						} else {
							logger.warn(untypedResponder + " does not implement the correct interface to use it as <" + node.name().localName + " />");
						}
					}
				}
			}
		}

		public function addResponderByInterface(inResponder : INavigationResponder, inPath : String) : void {
			try { 
				addResponderShow(inResponder as IHasStateTransition, inPath); 
			}catch(e : Error) {
				// ignore errors. 
			}
			
			try { 
				addResponderUpdate(inResponder as IHasStateUpdate, inPath); 
			}catch(e : Error) { 
				// ignore errors. 
			}
			
			try { 
				addResponderValidate(inResponder as IHasStateValidation, inPath); 
			}catch(e : Error) { 
				// ignore errors. 
			}
		}

		public function addResponderShow(inResponder : IHasStateTransition, inPath : String) : void {
			_navigator.addResponderShow(inResponder, inPath);
			sendNotification(RESPONDER_ADDED, inResponder, "show");
		}

		public function addResponderHide(inResponder : IHasStateTransition, inPath : String) : void {
			_navigator.addResponderHide(inResponder, inPath);
			sendNotification(RESPONDER_ADDED, inResponder, "hide");
		}

		public function removeResponderShow(inResponder : IHasStateTransition, inPath : String) : void {
			_navigator.removeResponderShow(inResponder, inPath);
			sendNotification(RESPONDER_REMOVED, inResponder, "show");
		}

		public function addResponderUpdate(inResponder : IHasStateUpdate, inPath : String) : void {
			_navigator.addResponderUpdate(inResponder, inPath);
			sendNotification(RESPONDER_ADDED, inResponder, "update");
		}

		public function addResponderValidate(inResponder : IHasStateValidation, inPath : String) : void {
			_navigator.addResponderValidate(inResponder, inPath);
			sendNotification(RESPONDER_ADDED, inResponder, "validate");
		}

		public function registerHiddenState(inState : NavigationState, inExactMatch : Boolean = false) : void {
			if (_navigator is SWFAddressNavigator) {
				SWFAddressNavigator(_navigator).registerHiddenState(inState, inExactMatch);
			}
		}

		/**
		 * Use this method when you want to pass in a simple string.
		 * If you already have a #NavigationState object, use the regular requestNewState() method.
		 */
		public function requestNewStateByPath(inPath : String) : void {
			_navigator.requestNewStateByPath(inPath);
		}

		/**
		 * Request a new state by providing a #NavigationState instance.
		 * If the new state is different from the current, it will be validated and granted.
		 */
		public function requestNewState(inNavigationState : NavigationState) : void {
			_navigator.requestNewState(inNavigationState);
		}

		public function getStatus(inResponder : IHasStateTransition) : int {
			return _navigator.getStatus(inResponder);
		}

		public function getCurrentState() : NavigationState {
			return _navigator.getCurrentState();
		}

		/**
		 * Use this getter only for development feedback.
		 */
		development function get navigator() : Navigator {
			return _navigator;
		}

		private function handleTransitionStatusUpdate(event : NavigatorEvent) : void {
			sendNotification(TRANSITION_STATUS_UPDATED, event.statusByResponder);
		}

		private function handleStateChanged(event : NavigatorEvent) : void {
			sendNotification(STATE_CHANGED, _navigator.getCurrentState());
		}
	}
}